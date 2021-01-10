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
                .current.date(byAdding: .hour, value: 12, to: Date()) ?? Date()
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

    let crippledColumns = [
        GridItem(.flexible()),
        GridItem(.fixed(17)),
        GridItem(.fixed(17)),
        GridItem(.fixed(17)),
    ]

    let fullColumns = [
        GridItem(.flexible()),
        GridItem(.fixed(16)),
        GridItem(.fixed(16)),
        GridItem(.fixed(16)),
        GridItem(.fixed(16)),
        GridItem(.fixed(16)),
        GridItem(.fixed(17)),
        GridItem(.fixed(16)),
    ]

    var entry: Provider.Entry

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            smallTable
        case .systemMedium:
            fullTable(prefix: 3)
        case .systemLarge:
            fullTable(prefix: 10)
        @unknown default:
            Text("Unsupported widget family")
        }
    }

    var smallTable: some View {
        VStack {
            ForEach(entry.standings) { standingsList in
                if let url = URL(string: standingsList.league.logo), let data = try? Data(contentsOf: url), let uiImg = UIImage(data: data) {
                    Image(uiImage: uiImg)
                        .resizable()
                        .frame(width: 20, height: 20)
                } else {
                    Image(systemName: "multiply.circle")
                        .imageScale(.large)
                }
                ForEach(standingsList.table, id: \.self) { table in
                    LazyVGrid(columns: crippledColumns, alignment: .leading) {
                        Text("TEAM")
                        Text("PL")
                        Text("W")
                        Text("PT")
                    }
                    ForEach(table.prefix(3), id: \.self) { row in
                        LazyVGrid(columns: crippledColumns, alignment: .leading) {
                            HStack {
                                Text("3")
                                    .hidden()
                                    .overlay(Text("\(row.rank)"))
                                if let url = URL(string: row.team.logo), let data = try? Data(contentsOf: url), let uiImg = UIImage(data: data) {
                                    Image(uiImage: uiImg)
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                } else {
                                    Image(systemName: "multiply.circle")
                                        .imageScale(.medium)
                                }
                            }
                            switch entry.type {
                            case .all:
                                smallTableRow(row: row.all)
                            case .home:
                                smallTableRow(row: row.home)
                            case .away:
                                smallTableRow(row: row.away)
                            case .unknown:
                                smallTableRow(row: row.all)
                            }
                        }
                    }
                }
                .font(.caption)
            }
        }
        .padding()
    }

    func fullTable(prefix: Int) -> some View {
        VStack {
            ForEach(entry.standings) { standingsList in
                HStack {
                    if let url = URL(string: standingsList.league.logo), let data = try? Data(contentsOf: url), let uiImg = UIImage(data: data) {
                        Image(uiImage: uiImg)
                            .resizable()
                            .frame(width: 20, height: 20)
                    } else {
                        Image(systemName: "multiply.circle")
                            .imageScale(.large)
                    }
                    Text(standingsList.league.name)
                        .lineLimit(1)
                }
                ForEach(standingsList.table, id: \.self) { table in
                    LazyVGrid(columns: fullColumns, alignment: .leading) {
                        Text("TEAM")
                        Text("PL")
                        Text("W")
                        Text("D")
                        Text("L")
                        Text("GF")
                        Text("GA")
                        Text("PT")
                    }
                    ForEach(table.prefix(prefix), id: \.self) { row in
                        LazyVGrid(columns: fullColumns, alignment: .leading) {
                            HStack {
                                Text("20")
                                    .hidden()
                                    .overlay(Text("\(row.rank)"))
                                if let url = URL(string: row.team.logo), let data = try? Data(contentsOf: url), let uiImg = UIImage(data: data) {
                                    Image(uiImage: uiImg)
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                } else {
                                    Image(systemName: "multiply.circle")
                                        .imageScale(.medium)
                                }
                                Text("\(row.team.name)")
                                    .lineLimit(1)
                            }
                            switch entry.type {
                            case .all:
                                fullTableRow(row: row.all)
                            case .home:
                                fullTableRow(row: row.home)
                            case .away:
                                fullTableRow(row: row.away)
                            case .unknown:
                                fullTableRow(row: row.all)
                            }
                        }
                    }
                }
                .font(.caption)
            }
        }
        .padding()
    }

    func fullTableRow(row: StandingsStatistics) -> some View {
        Group {
            Text("\(row.played)")
            Text("\(row.win)")
            Text("\(row.draw)")
            Text("\(row.lose)")
            Text("\(row.goalsFor)")
            Text("\(row.goalsAgainst)")
            Text("\(row.win * 3 + row.draw)")
        }
    }

    func smallTableRow(row: StandingsStatistics) -> some View {
        Group {
            Text("\(row.played)")
            Text("\(row.win)")
            Text("\(row.win * 3 + row.draw)")
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
                .background(Color(.secondarySystemBackground))
        }
        .configurationDisplayName("Standings")
        .description("See standings from the seleceted league.")
    }
}
