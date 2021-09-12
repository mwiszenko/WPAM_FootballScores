//
//  LeagueWidget.swift
//  LeagueWidget
//
//  Created by Michal on 03/01/2021.
//

import Intents
import SwiftUI
import WidgetKit

struct Provider: IntentTimelineProvider {
    var data = ModelData()

    let placeholderStandings: [Standings] = ModelData.getPlaceholderStandings()

    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), type: Types.all, standings: placeholderStandings, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), type: configuration.type, standings: placeholderStandings, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var leagueIndex: Int
        switch configuration.league {
        case .premierLeague:
            leagueIndex = 39
        case .laLiga:
            leagueIndex = 140
        case .serieA:
            leagueIndex = 135
        case .bundesliga:
            leagueIndex = 78
        case .ligue1:
            leagueIndex = 61
        case .ekstraklasa:
            leagueIndex = 106
        case .unknown:
            leagueIndex = 39
        }
        data.fetchStandings(id: leagueIndex) { standings in
            let entry = SimpleEntry(date: Date(), type: configuration.type, standings: standings, configuration: configuration)
            let expiryDate = Calendar
                .current.date(byAdding: .hour, value: 24, to: Date()) ?? Date()
            let timeline = Timeline(entries: [entry], policy: .after(expiryDate))
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let type: Types
    let standings: [Standings]
    let configuration: ConfigurationIntent
}

struct LeagueWidgetEntryView: View {
    @Environment(\.widgetFamily) var widgetFamily


    var entry: Provider.Entry

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            smallTable(prefix: 3)
        case .systemMedium:
            fullTable(prefix: 3)
        case .systemLarge:
            fullTable(prefix: 10)
        @unknown default:
            Text("Unsupported widget family")
        }
    }
}

// MARK: - Full table

extension LeagueWidgetEntryView {
    func fullTable(prefix: Int) -> some View {
        VStack {
            HStack {
                if let url = URL(string: entry.standings[0].league.logo), let data = try? Data(contentsOf: url), let uiImg = UIImage(data: data) {
                    Image(uiImage: uiImg)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image(systemName: "multiply.circle")
                        .imageScale(.large)
                }
                Text(entry.standings[0].league.name)
                    .lineLimit(1)
            }
            HStack {
                Text("TEAM")
                Spacer()
                Text("00")
                    .hidden()
                    .overlay(Text("PL"))
                Text("00")
                    .hidden()
                    .overlay(Text("W"))
                Text("00")
                    .hidden()
                    .overlay(Text("D"))
                Text("00")
                    .hidden()
                    .overlay(Text("L"))
                Text("GF")
                    .hidden()
                    .overlay(Text("GF"))
                Text("GA")
                    .hidden()
                    .overlay(Text("GA"))
                Text("PT")
                    .hidden()
                    .overlay(Text("PT"))
            }
            .font(.footnote)
            ForEach(entry.standings[0].table[0].prefix(prefix), id: \.self) { row in
                fullTableRow(row: row)
            }
            .font(.footnote)
        }
        .padding()
    }
    
    func fullTableRow(row: StandingsRow) -> some View {
        HStack {
            HStack {
                Text("00")
                    .hidden()
                    .overlay(Text("\(row.rank)"))
                if let url = URL(string: row.team.logo), let data = try? Data(contentsOf: url), let uiImg = UIImage(data: data) {
                    Image(uiImage: uiImg)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image(systemName: "multiply.circle")
                        .imageScale(.medium)
                }
                Text("\(row.team.name)")
                    .lineLimit(1)
            }
            Spacer()
            switch entry.type {
            case .all:
                fullTableStats(row: row.all)
            case .home:
                fullTableStats(row: row.home)
            case .away:
                fullTableStats(row: row.away)
            case .unknown:
                fullTableStats(row: row.all)
            }
        }
    }


    func fullTableStats(row: StandingsStatistics) -> some View {
        Group {
            Text("00")
                .hidden()
                .overlay(Text("\(row.played)"))
            Text("00")
                .hidden()
                .overlay(Text("\(row.win)"))
            Text("00")
                .hidden()
                .overlay(Text("\(row.draw)"))
            Text("00")
                .hidden()
                .overlay(Text("\(row.lose)"))
            Text("GF")
                .hidden()
                .overlay(Text("\(row.goalsFor)"))
            Text("GA")
                .hidden()
                .overlay(Text("\(row.goalsAgainst)"))
            Text("PT")
                .hidden()
                .overlay(Text("\(row.win * 3 + row.draw)"))
        }
    }
}

// MARK: - Full table

extension LeagueWidgetEntryView {
    func smallTable(prefix: Int) -> some View {
        VStack {
            if let url = URL(string: entry.standings[0].league.logo), let data = try? Data(contentsOf: url), let uiImg = UIImage(data: data) {
                Image(uiImage: uiImg)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(systemName: "multiply.circle")
                    .imageScale(.large)
            }
            HStack {
                Text("TEAM")
                Spacer()
                Text("00")
                    .hidden()
                    .overlay(Text("PL"))
                Text("00")
                    .hidden()
                    .overlay(Text("W"))
                Text("PT")
                    .hidden()
                    .overlay(Text("PT"))
            }
            .font(.footnote)
            ForEach(entry.standings[0].table[0].prefix(prefix), id: \.self) { row in
                smallTableRow(row: row)
            }
            .font(.footnote)
        }
        .padding()
    }

    func smallTableRow(row: StandingsRow) -> some View {
        HStack {
            HStack {
                Text("0")
                    .hidden()
                    .overlay(Text("\(row.rank)"))
                if let url = URL(string: row.team.logo), let data = try? Data(contentsOf: url), let uiImg = UIImage(data: data) {
                    Image(uiImage: uiImg)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image(systemName: "multiply.circle")
                        .imageScale(.medium)
                }
            }
            Spacer()
            switch entry.type {
            case .all:
                smallTableStats(row: row.all)
            case .home:
                smallTableStats(row: row.home)
            case .away:
                smallTableStats(row: row.away)
            case .unknown:
                smallTableStats(row: row.all)
            }
        }
    }

    func smallTableStats(row: StandingsStatistics) -> some View {
        Group {
            Text("00")
                .hidden()
                .overlay(Text("\(row.played)"))
            Text("00")
                .hidden()
                .overlay(Text("\(row.win)"))
            Text("PT")
                .hidden()
                .overlay(Text("\(row.win * 3 + row.draw)"))
        }
    }
}

@main
struct LeagueWidget: Widget {
    let kind: String = "LeagueWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            LeagueWidgetEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
        }
        .configurationDisplayName("Standings")
        .description("See standings from the seleceted league.")
    }
}
