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
    
    var body: some View {
        NavigationView {
            List {
                ForEach(modelData.fixturesDict
                            .filter { favourites.contains($0.key.id) }
                            .sorted { (first, second) -> Bool in
                                return first.key.country < second.key.country
                            }, id: \.key) { key, value in
                    Section(header: Text(key.country + " - " + key.name)) {
                        ForEach(value) { fixture in
                            NavigationLink(destination: FixtureDetailView(fixture: fixture)) {
                                FixtureRowView(fixture: fixture)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favourites")
            .listStyle(InsetGroupedListStyle())
        }
    }
}
