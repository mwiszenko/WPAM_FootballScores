//
//  LeagueDetailView.swift
//  FootballScores
//
//  Created by Michal on 29/12/2020.
//

import SwiftUI

struct LeagueDetailView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var favourites: Favourites
    
    var standings: [Int: [Standings]] {
        modelData.standingsDict
            .filter { $0.key == league.id }
    }

    var league: League
    
    @State private var sliderValue: Int = 0
    private let sliderValues: [String] = ["ALL", "HOME", "AWAY"]

    var body: some View {
        VStack {
            if !standings.isEmpty {
                RemoteImage(url: league.logo)
                    .frame(width: 100, height: 100)
                    .padding()
                
                Text(league.name)
                
                tables
            } else {
                ProgressView("Loading")
            }
        }
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { favourites.contains(league.id) ? favourites.remove(league.id) : favourites.add(league.id) }) {
                    if favourites.contains(league.id) {
                        Image(systemName: "star.fill")
                            .imageScale(.large)
                    } else {
                        Image(systemName: "star")
                            .imageScale(.large)
                    }
                }
                .foregroundColor(.accentColor)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { modelData.loadStandings(id: league.id) }) {
                    Image(systemName: "arrow.clockwise")
                        .imageScale(.large)
                }
                .foregroundColor(.accentColor)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension LeagueDetailView {
    @ViewBuilder
    var tables: some View {
        ForEach(standings
            .sorted { (first, second) -> Bool in
                first.key < second.key
            }, id: \.key) { fixtureId, standingsList in
            if !standingsList.isEmpty {
                typePicker
                List {
                    ForEach(standingsList) { standingsList in
                        ForEach(standingsList.table, id: \.self) { table in
                            Section {
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
                                ForEach(table, id: \.self) { row in
                                    TableRowView(row: row, type: self.sliderValues[sliderValue])
                                }
                                .font(.footnote)
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            } else {
                Text("No data available")
            }
        }
    }
    
    var typePicker: some View {
        Picker("TableType", selection: $sliderValue) {
            ForEach(0 ..< sliderValues.count) { index in
                Text(self.sliderValues[index]).tag(index)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .aspectRatio(contentMode: .fit)
    }
}
