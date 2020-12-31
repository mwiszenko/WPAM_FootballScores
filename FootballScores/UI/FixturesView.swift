//
//  FixturesView.swift
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
                    leagueSection(key: key, value: value)
                }
            }
            .navigationTitle("Fixtures")
            .listStyle(InsetGroupedListStyle())
        }
    }
}

private extension FixturesView {
    func leagueSection(key: FixtureLeague, value: [Fixture]) -> some View {
        return Section(header: Text(key.country + " - " + key.name)) {
            ForEach(value) { fixture in
                NavigationLink(destination: FixtureDetailView(fixture: fixture)) {
                    FixtureRowView(fixture: fixture)
                }
            }
        }
    }
}
