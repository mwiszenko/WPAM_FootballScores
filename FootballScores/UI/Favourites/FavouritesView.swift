//
//  FavouritesView.swift
//  FootballScores
//
//  Created by Michal on 13/12/2020.
//

import SwiftUI

struct FavouritesView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var favourites: Favourites
    
    var favouriteFixtures: [FixtureLeague: [Fixture]] {
        modelData.fixturesDict
                    .filter { favourites.contains($0.key.id) }
    }
    
    var favouriteLeagues: [League] {
        modelData.leagues
            .filter {
                return favourites.contains($0.id)
            }
    }
    
    var body: some View {
        NavigationView {
            List {
                if !favouriteLeagues.isEmpty {
                    leagues
                }  else {
                    Section(header: Text("Leagues")) {
                        Text("No favourite leagues")
                    }
                }
                
                if !favouriteFixtures.isEmpty {
                    fixtures
                } else {
                    Section(header: Text("Fixtures")) {
                        Text("No favourite fixtures")
                    }
                }
            }
            .navigationTitle("Favourites")
            .listStyle(InsetGroupedListStyle())
        }
    }
}

extension FavouritesView {
    var leagues: some View {
        Section(header: EditButton().frame(maxWidth: .infinity, alignment: .trailing)
                        .overlay(Text("Leagues"), alignment: .leading)) {
            ForEach(favouriteLeagues
                        .sorted { (first, second) -> Bool in
                            return favourites.leagues.firstIndex(of: first.id)! < favourites.leagues.firstIndex(of: second.id)!
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
    
    var fixtures: some View {
        ForEach(favouriteFixtures.sorted { (first, second) -> Bool in
            return favourites.leagues.firstIndex(of: first.key.id)! < favourites.leagues.firstIndex(of: second.key.id)!
        }, id: \.key) { key, value in
            Section(header: Text(key.country + " - " + key.name)) {
                ForEach(value) { fixture in
                    NavigationLink(destination: FixtureDetailView(fixture: fixture)
                                    .onAppear(perform: {
                                        if modelData.eventsDict[fixture.id] == nil {
                                            modelData.loadEvents(id: fixture.id)
                                        }
                                    if modelData.statisticsDict[fixture.id] == nil {
                                        modelData.loadStatistics(id: fixture.id)
                                    }
                                    })
                    ) {
                        FixtureRowView(fixture: fixture)
                    }
                }
            }
        }
    }
}
