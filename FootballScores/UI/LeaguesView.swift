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
    
    var searchedLeagues: [String: [League]] {
        modelData.leaguesDict
            .filter { if searchPhrase != "" {
                return $0.key.localizedCaseInsensitiveContains(searchPhrase)
            } else {
                return true
            }
        }
    }
    
    var favouriteLeagues: [League] {
        modelData.leagues
            .filter { if searchPhrase != "" {
                return $0.country.localizedCaseInsensitiveContains(searchPhrase) && favourites.contains($0.id)
            } else {
                return favourites.contains($0.id)
            }
        }
            .sorted {
                
        }
    }

    var body: some View {
        NavigationView {
            List {
                searchBar
                
                if !favouriteLeagues.isEmpty {
                    favouritesSection
                }
                
                countriesSection
            }
            .navigationTitle("Leagues")
            .listStyle(InsetGroupedListStyle())
        }
    }
}


extension LeaguesView {
    var searchBar: some View {
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
    }
    
    var favouritesSection: some View {
        Section(header: Text("Favourites")) {
            EditButton()
            ForEach(favouriteLeagues) { league in
                NavigationLink(destination: LeagueDetailView(league: league)
//                                                .onAppear(perform: {
//                                                            if modelData.standingsDict[league.id] == nil {
//                                                                modelData.loadStandings(id: league.id)
//                                                            }
//                                                })
                ) {
                    LeagueRowView(league: league)
                }
            }
            .onMove {
                print($0, $1)
            }
        }
    }
    
    var countriesSection: some View {
        ForEach(searchedLeagues
                    .sorted { (first, second) -> Bool in
            return first.key < second.key
        }, id: \.key) { key, value in
            Section(header: Text(key)) {
                ForEach(value) { league in
                    NavigationLink(destination: LeagueDetailView(league: league)
//                                                    .onAppear(perform: {
//                                                        if modelData.standingsDict[league.id] == nil {
//                                                            modelData.loadStandings(id: league.id)
//                                                        }
//                                                    })
                    ) {
                        LeagueRowView(league: league)
                    }
                }
            }
        }
    }
}
