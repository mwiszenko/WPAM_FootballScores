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

    var fixtureIndex: Int {
        modelData.leagues.firstIndex(where: { $0.id == league.id })!
    }
    
    @State private var sliderValue: Int = 0
    private let sliderValues = ["ALL", "HOME", "AWAY"]

    var body: some View {
        VStack {
            Button(action: {favourites.contains(league.id) ? favourites.remove(league.id) : favourites.add(league.id)}) {
                if favourites.contains(league.id) {
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                } else {
                    Image(systemName: "star")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            }
            .offset(x: 150, y: -15)
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(.yellow)
            
            RemoteImage(url: league.logo)
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                
            
            Text(league.name)
            
            Picker("Abc", selection: $sliderValue) {
                ForEach(0 ..< sliderValues.count) { index in
                    Text(self.sliderValues[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .aspectRatio(contentMode: .fit)

            ForEach(modelData.standings) { standings in
                List {
                    ForEach(standings.table, id: \.self) { matrix in
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
                            ForEach(matrix, id: \.self) { row in
                                TableRowView(row: row, type: self.sliderValues[sliderValue])
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
    }
}
