//
//  LeaguesView.swift
//  FootballScores
//
//  Created by Michal on 13/12/2020.
//

import SwiftUI

struct LeaguesView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var favourites: Favourites
    
    @State private var searchPhrase: String = ""

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Search by country")) {
                    HStack {
                        TextField("Enter search criteria...", text: $searchPhrase)
                            .background(Color.clear)
                        if searchPhrase == "" {
                            Image(systemName: "magnifyingglass")
                        } else {
                            Button(action: {
                                searchPhrase = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                            }
                            .buttonStyle(PlainButtonStyle())
                            .foregroundColor(.primary)
                        }
                    }
                }
                
                if !favourites.isEmpty() {
                    Section(header: Text("Favourites")) {
                        ForEach(modelData.leaguesDict.sorted { (first, second) -> Bool in
                            return first.key < second.key
                        }, id: \.key) { key, value in
                            ForEach(value.filter { favourites.contains($0.id) }) { league in
                                NavigationLink(destination: LeagueDetailView(league: league)
                                                .onAppear(perform: {
                                                    modelData.loadStandings(id: league.id)
                                                })
                                ) {
                                    LeagueRowView(league: league)
                                }
                            }
                        }
                    }
                }
                
                ForEach(modelData.leaguesDict
                            .filter { if searchPhrase != "" {
                                    return $0.key.localizedCaseInsensitiveContains(searchPhrase)
                                } else {
                                    return true
                                }
                            }
                            .sorted { (first, second) -> Bool in
                    return first.key < second.key
                }, id: \.key) { key, value in
                    Section(header: Text(key)) {
                        ForEach(value) { league in
                            NavigationLink(destination: LeagueDetailView(league: league)
//                                            .onAppear(perform: {
//                                                modelData.loadStandings(id: league.id)
//                                            })
                            ) {
                                LeagueRowView(league: league)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Leagues")
            .listStyle(InsetGroupedListStyle())
        }
    }
}

struct LeaguesView_Previews: PreviewProvider {
    static var previews: some View {
        LeaguesView()
            .colorScheme(.dark)
            .environmentObject(ModelData())
            .environmentObject(Favourites())
    }
}
