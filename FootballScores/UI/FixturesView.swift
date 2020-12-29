//
//  MatchesView.swift
//  FootballScores
//
//  Created by Michal on 13/12/2020.
//

import SwiftUI

struct FixturesView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var favourites: Favourites

    var body: some View {
        NavigationView {
            List {
                ForEach(modelData.fixturesDict.sorted { (first, second) -> Bool in
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
            .navigationTitle("Fixtures")
            .listStyle(InsetGroupedListStyle())
        }
    }
}

struct FixturesView_Previews: PreviewProvider {
    static var previews: some View {
        FixturesView()
            .colorScheme(.dark)
            .environmentObject(ModelData())
            .environmentObject(Favourites())
    }
}
