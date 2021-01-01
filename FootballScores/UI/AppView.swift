//
//  AppView.swift
//  FootballScores
//
//  Created by Michal on 13/12/2020.
//

import SwiftUI

struct AppView: View {
    var body: some View {
        TabView {
            FixturesView()
                .tabItem {
                    Image(systemName: "sportscourt")
                    Text("Fixtures")
                }

            LeaguesView()
                .tabItem {
                    Image(systemName: "note")
                    Text("Leagues")
                }

            FavouritesView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favourites")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .colorScheme(.dark)
            .environmentObject(ModelData())
            .environmentObject(Favourites())
    }
}
