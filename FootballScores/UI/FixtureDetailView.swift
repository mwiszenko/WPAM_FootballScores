//
//  FixtureDetailView.swift
//  FootballScores
//
//  Created by Michal on 22/12/2020.
//

import SwiftUI

struct FixtureDetailView: View {
    @EnvironmentObject var modelData: ModelData
    
    var events: [Int: [Event]] {
        modelData.eventsDict
            .filter { $0.key == fixture.id }
    }
    
    var statistics: [Int: [Statistics]] {
        modelData.statisticsDict
            .filter { $0.key == fixture.id }
    }
    
    let statisticTypes: [String] = ["SHOTS ON GOAL", "SHOTS"]
    
    var fixture: Fixture

    var body: some View {
        VStack(spacing: 0) {
            header
                .padding()
            
            eventScroller
            
            statisticsTable
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension FixtureDetailView {
    var header: some View {
        HStack {
            Spacer()
            RemoteImage(url: fixture.homeTeam.logo)
                .frame(width: 100, height: 100)
            Spacer()
            if fixture.homeGoals != nil && fixture.awayGoals != nil {
                Text("\(fixture.homeGoals ?? 0) - \(fixture.homeGoals ?? 0)")
            } else {
                Text(fixture.date.addingTimeInterval(600), style: .time)
            }
            Spacer()
            RemoteImage(url: fixture.awayTeam.logo)
                .frame(width: 100, height: 100)
            Spacer()
        }
    }
    
    var eventScroller: some View {
        ForEach(events.sorted { (first, second) -> Bool in
            return first.key < second.key
        }, id: \.key) { key, value in
            if !value.isEmpty {
                VStack {
                    Text("EVENTS")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.footnote)
                    
                    HStack() {
                        VStack() {
                            RemoteImage(url: fixture.homeTeam.logo)
                                .frame(width: 40, height: 40)
                            Spacer()
                            RemoteImage(url: fixture.awayTeam.logo)
                                .frame(width: 40, height: 40)
                        }

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(value, id: \.self) { event in
                                    if fixture.homeTeam.id == event.teamId {
                                        VStack {
                                            Group {
                                                Text(event.detail)
                                                Text(event.playerName)
                                                Text("\(event.elapsed)")
                                            }
                                            .font(.caption)
                                            Spacer()
                                        }
                                    } else if fixture.awayTeam.id == event.teamId {
                                        VStack {
                                            Spacer()
                                            Group {
                                                Text("\(event.elapsed)")
                                                Text(event.playerName)
                                                Text(event.detail)
                                            }
                                            .font(.caption)
                                        }
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
    
    var statisticsTable: some View {
        HStack {
            ForEach(statistics.sorted { (first, second) -> Bool in
                return first.key < second.key
            }, id: \.key) { key, value in
                if value.count == 2 {
                    List {
                        ForEach(value[0].stats, id: \.self) { stat in
                            if let index = value[1].stats.firstIndex(where: {$0.type == stat.type}) {
                                Section(header: Text(stat.type)) {
                                    HStack {
                                        Spacer()
                                        Text(stat.value ?? "0")
                                        Spacer()
                                        Spacer()
                                        Spacer()
                                        Text(value[1].stats[index].value ?? "0")
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
}
