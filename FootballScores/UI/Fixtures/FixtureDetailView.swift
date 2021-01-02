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
        
    let showElapsed: [String] = ["1H", "2H", "ET"]
    
    let showStatus: [String] = ["NS", "FT", "HT", "AET", "PEN", "BT", "SUSP", "INT", "PST", "CANC", "ABD", "AWD", "WO"]
    
    let statisticTypes: [String] = ["SHOTS ON GOAL", "SHOTS"]
    
    var fixture: Fixture

    var body: some View {
        VStack(spacing: 0) {
            if !statistics.isEmpty && !events.isEmpty {
                header
                    .padding()
                
                eventScroller
                
                statisticsTable
            } else {
                ProgressView("Loading")
            }
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
            VStack {

                if fixture.homeGoals != nil && fixture.awayGoals != nil {
                    Text("\(fixture.homeGoals ?? 0) - \(fixture.awayGoals ?? 0)")
                } else {
                    Text(fixture.date.addingTimeInterval(600), style: .time)
                }
                    
                if showElapsed.contains(fixture.status.short) {
                    Text("\(fixture.status.elapsed ?? 0)" + "'")
                        .font(.system(size: 12))
                } else {
                    Text(fixture.status.short)
                        .font(.system(size: 12))
                }

            }

            Spacer()
            RemoteImage(url: fixture.awayTeam.logo)
                .frame(width: 100, height: 100)
            Spacer()
        }
    }
    
    var eventScroller: some View {
        ForEach(events.sorted { (first, second) -> Bool in
            first.key < second.key
        }, id: \.key) { _, value in
            if !value.isEmpty {
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
                                ForEach(value, id: \.self) { event in
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
    
    var statisticsTable: some View {
        HStack {
            ForEach(statistics.sorted { (first, second) -> Bool in
                first.key < second.key
            }, id: \.key) { _, value in
                if value.count == 2 {
                    List {
                        ForEach(value[0].stats, id: \.self) { stat in
                            if let index = value[1].stats.firstIndex(where: { $0.type == stat.type }) {
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