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

    var fixtureIndex: Int {
        modelData.leagues.firstIndex(where: { $0.id == league.id })!
    }

    var body: some View {
        VStack {
            RemoteImage(url: league.logo)
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
            Text("\(league.id)")
            Text(league.name)
            Button(favourites.contains(self.league.id) ? "Remove from Favorites" : "Add to Favorites") {
                if self.favourites.contains(self.league.id) {
                    self.favourites.remove(self.league.id)
                } else {
                    self.favourites.add(self.league.id)
                }
            }
            .padding()
        }
    }
}

struct LeagueDetailView_Previews: PreviewProvider {
    static let modelData = ModelData()
    static let favourites = Favourites()

    static var previews: some View {
        LeagueDetailView(league: modelData.leagues[0])
            .environmentObject(modelData)
            .environmentObject(favourites)
    }
}
