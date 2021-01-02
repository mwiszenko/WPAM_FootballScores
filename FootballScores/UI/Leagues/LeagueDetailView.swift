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
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.fixed(15)),
        GridItem(.fixed(15)),
        GridItem(.fixed(15)),
        GridItem(.fixed(15)),
        GridItem(.fixed(15)),
        GridItem(.fixed(15)),
        GridItem(.fixed(15)),
    ]
    
    @State private var sliderValue: Int = 0
    private let sliderValues = ["ALL", "HOME", "AWAY"]

    var body: some View {
        VStack {
            if !standings.isEmpty {
                RemoteImage(url: league.logo)
                    .aspectRatio(contentMode: .fit)
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
                .foregroundColor(.yellow)
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
            }, id: \.key) { _, value in
            typePicker
            
            List {
                ForEach(value) { matrix in
                    ForEach(matrix.table, id: \.self) { abc in
                        Section {
                            LazyVGrid(columns: columns, alignment: .leading) {
                                Group {
                                    Text("TEAM")
                                    Text("PL")
                                    Text("W")
                                    Text("D")
                                    Text("L")
                                    Text("GF")
                                    Text("GA")
                                    Text("PTS")
                                }
                                .fixedSize(horizontal: true, vertical: false)
                            }
                            .font(.system(size: 10))
                            ForEach(abc, id: \.self) { row in
                                TableRowView(row: row, type: self.sliderValues[sliderValue])
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
    
    var typePicker: some View {
        Picker("Abc", selection: $sliderValue) {
            ForEach(0 ..< sliderValues.count) { index in
                Text(self.sliderValues[index]).tag(index)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .aspectRatio(contentMode: .fit)
    }
}
