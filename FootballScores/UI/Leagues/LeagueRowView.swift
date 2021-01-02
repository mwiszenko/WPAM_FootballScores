//
//  LeagueRowView.swift
//  FootballScores
//
//  Created by Michal on 27/12/2020.
//

import SwiftUI

struct LeagueRowView: View {
    @EnvironmentObject var favourites: Favourites

    var league: League

    var body: some View {
        HStack {
            RemoteImage(url: self.league.logo)
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
            Text(self.league.name)
            Spacer()
            Button(action: { favourites.contains(league.id) ? favourites.remove(league.id) : favourites.add(league.id) }) {
                if favourites.contains(league.id) {
                    Image(systemName: "star.fill")
                } else {
                    Image(systemName: "star")
                }
            }
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(.yellow)
        }
    }
}
