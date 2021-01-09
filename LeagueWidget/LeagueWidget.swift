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
    
    let leagueIndex = 39

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), standings: [], configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), standings: [], configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        data.fetchStandings(id: leagueIndex) { standings in
            let entry = SimpleEntry(date: Date(), standings: standings, configuration: configuration)

            let expiryDate = Calendar
                .current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
            let timeline = Timeline(entries: [entry], policy: .after(expiryDate))
            completion(timeline)
        }
    }

    struct SimpleEntry: TimelineEntry {
        let date: Date
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
            GridItem(.fixed(17)),
            GridItem(.fixed(17)),
            GridItem(.fixed(17)),
            GridItem(.fixed(17)),
            GridItem(.fixed(17)),
            GridItem(.fixed(17)),
            GridItem(.fixed(17)),
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
                    Image(uiImage: UIImage(data: try! Data(contentsOf: URL(string: standingsList.league.logo)!))!)
                        .resizable()
                        .frame(width: 20, height: 20)
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
                                    Image(uiImage: UIImage(data: try! Data(contentsOf: URL(string: row.team.logo)!))!)
                                        .resizable()
                                        .frame(width: 20, height: 20)
//                                    Text("\(row.team.name)")
//                                        .multilineTextAlignment(.leading)
                                }
                                Text("\(row.all.played)")
                                Text("\(row.all.win)")
                                Text("\(row.points)")
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
                        Image(uiImage: UIImage(data: try! Data(contentsOf: URL(string: standingsList.league.logo)!))!)
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(standingsList.league.name)
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
                                    Image(uiImage: UIImage(data: try! Data(contentsOf: URL(string: row.team.logo)!))!)
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    Text("\(row.team.name)")
                                        .multilineTextAlignment(.leading)
                                }
                                Text("\(row.all.played)")
                                Text("\(row.all.win)")
                                Text("\(row.all.draw)")
                                Text("\(row.all.lose)")
                                Text("\(row.all.goalsFor)")
                                Text("\(row.all.goalsAgainst)")
                                Text("\(row.points)")
                            }
                        }
                    }
                    .font(.caption)
                }
            }
            .padding()
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
            .configurationDisplayName("League")
            .description("This is a widget for displaying league table.")
        }
    }
}
