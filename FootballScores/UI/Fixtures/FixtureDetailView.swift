//
//  FixtureDetailView.swift
//  FootballScores
//
//  Created by Michal on 22/12/2020.
//

import SwiftUI

struct FixtureDetailView: View {
    @EnvironmentObject var modelData: ModelData

    let showElapsed: [String] = ["1H", "2H", "ET"]
    let showStatus: [String] = ["NS", "FT", "HT", "AET", "PEN", "BT", "SUSP", "INT", "PST", "CANC", "ABD", "AWD", "WO"]

    var fixture: Fixture

    var body: some View {
        VStack(spacing: 0) {
            if !statistics.isEmpty, !events.isEmpty {
                header
                    .padding()

                eventScroller

                statisticsTable
            } else {
                ProgressView("Loading")
            }
        }
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { modelData.loadFixtures() }) {
                    Image(systemName: "arrow.clockwise")
                        .imageScale(.large)
                }
                .foregroundColor(.accentColor)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Header

extension FixtureDetailView {
    var header: some View {
        HStack {
            Spacer()
            RemoteImage(url: fixture.homeTeam.logo)
                .frame(width: 100, height: 100)
            Spacer()
            VStack {
                if fixture.homeGoals != nil && fixture.awayGoals != nil {
                    Text("\(fixture.homeGoals ?? 0) - \(fixture.awayGoals ?? 0)")
                } else {
                    Text(fixture.date.addingTimeInterval(600), style: .time)
                }

                if showElapsed.contains(fixture.status.short) {
                    Text("\(fixture.status.elapsed ?? 0)" + "'")
                        .foregroundColor(.green)
                } else {
                    Text(fixture.status.short)
                }
            }
            .font(.largeTitle)

            Spacer()
            RemoteImage(url: fixture.awayTeam.logo)
                .frame(width: 100, height: 100)
            Spacer()
        }
    }
}

// MARK: - Events

extension FixtureDetailView {
    var events: [Int: [Event]] {
        modelData.eventsDict
            .filter { $0.key == fixture.id }
    }

    var eventScroller: some View {
        ForEach(events.sorted { (first, second) -> Bool in
            first.key < second.key
        }, id: \.key) { _, eventList in
            if !eventList.isEmpty {
                VStack {
                    Text("EVENTS")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.footnote)

                    HStack {
                        VStack {
                            RemoteImage(url: fixture.homeTeam.logo)
                                .frame(width: 40, height: 40)
                            Spacer()
                            RemoteImage(url: fixture.awayTeam.logo)
                                .frame(width: 40, height: 40)
                        }

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(eventList, id: \.self) { event in
                                    if fixture.homeTeam.id == event.teamId {
                                        homeEvent(event: event)
                                    } else if fixture.awayTeam.id == event.teamId {
                                        awayEvent(event: event)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .fixedSize(horizontal: false, vertical: true)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                }
                .padding()
            }
        }
    }

    func awayEvent(event: Event) -> some View {
        VStack {
            Spacer()
            Group {
                Text("\(event.elapsed)")
                Text(event.playerName ?? "-")
                Text(event.detail)
            }
            .font(.caption)
        }
    }

    func homeEvent(event: Event) -> some View {
        VStack {
            Group {
                Text(event.detail)
                Text(event.playerName ?? "-")
                Text("\(event.elapsed)")
            }
            .font(.caption)
            Spacer()
        }
    }
}

// MARK: - Statistics

extension FixtureDetailView {
    var statistics: [Int: [Statistics]] {
        modelData.statisticsDict
            .filter { $0.key == fixture.id }
    }

    var statisticsTable: some View {
        ForEach(statistics.sorted { (first, second) -> Bool in
            first.key < second.key
        }, id: \.key) { key, statisticsList in
            if statisticsList.count == 2 {
                List {
                    ForEach(statisticsList[0].stats, id: \.self) { statistic in
                        if let index = statisticsList[1].stats.firstIndex(where: { $0.type == statistic.type }) {
                            Section(header: Text(statistic.type)) {
                                HStack {
                                    Spacer()
                                    Text(statistic.value ?? "0")
                                    Spacer()
                                    Spacer()
                                    Spacer()
                                    Text(statisticsList[1].stats[index].value ?? "0")
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
    }
}
