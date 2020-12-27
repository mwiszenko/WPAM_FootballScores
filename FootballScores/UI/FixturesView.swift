//
//  MatchesView.swift
//  FootballScores
//
//  Created by Michal on 13/12/2020.
//

import SwiftUI

struct FixturesView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showFavoritesOnly = false

    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favorites only")
                }
                
                ForEach(modelData.fixtures) { fixture in
                    NavigationLink(destination: FixtureDetailView(fixture: fixture)) {
                        FixtureRowView(fixture: fixture)
                    }
                }
            }
            .navigationTitle("Fixtures")
        }
    }
}

struct FixturesView_Previews: PreviewProvider {
    static var previews: some View {
        FixturesView()
            .environmentObject(ModelData())
    }
}
