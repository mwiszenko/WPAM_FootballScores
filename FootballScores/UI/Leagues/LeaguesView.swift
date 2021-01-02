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
            .filter {
                favourites.contains($0.id)
            }
    }

    var body: some View {
        NavigationView {
            if !modelData.leagues.isEmpty {
                List {
                    searchBar
                    
                    if !favouriteLeagues.isEmpty && searchPhrase == "" {
                        favouritesSection
                    }
                    
                    countriesSection
                }
                .navigationTitle("Leagues")
                .listStyle(InsetGroupedListStyle())
            } else {
                ProgressView("Loading")
            }
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
        Section(header: EditButton().frame(maxWidth: .infinity, alignment: .trailing)
            .overlay(Text("Favourites"), alignment: .leading)) {
            ForEach(favouriteLeagues
                .sorted { (first, second) -> Bool in
                    favourites.leagues.firstIndex(of: first.id)! < favourites.leagues.firstIndex(of: second.id)!
                }) { league in
                NavigationLink(destination: LeagueDetailView(league: league)
                    .onAppear(perform: {
                        if modelData.standingsDict[league.id] == nil {
                            modelData.loadStandings(id: league.id)
                        }
                    })
                ) {
                    LeagueRowView(league: league)
                }
            }
            .onMove { source, destination in
                favourites.move(source: source, destination: destination)
            }
        }
    }
    
    var countriesSection: some View {
        ForEach(searchedLeagues
            .sorted { (first, second) -> Bool in
                first.key < second.key
            }, id: \.key) { key, value in
            Section(header: Text(key)) {
                ForEach(value) { league in
                    NavigationLink(destination: LeagueDetailView(league: league)
                        .onAppear(perform: {
                            if modelData.standingsDict[league.id] == nil {
                                modelData.loadStandings(id: league.id)
                            }
                        })
                    ) {
                        LeagueRowView(league: league)
                    }
                }
            }
        }
    }
}
