//
//  LeaguesView.swift
//  FootballScores
//
//  Created by Michal on 13/12/2020.
//

import SwiftUI

struct LeaguesView: View {
    @EnvironmentObject var modelData: ModelData

    var body: some View {
        NavigationView {
            List {
                ForEach(modelData.leagues) { league in
//                    NavigationLink(destination: LeagueDetailView(league: league)) {
                        LeagueRowView(league: league)
//                    }
                }
            }
            .navigationTitle("Leagues")
        }    }
}

struct LeaguesView_Previews: PreviewProvider {
    static var previews: some View {
        LeaguesView()
            .colorScheme(.dark)
            .environmentObject(ModelData())
    }
}
