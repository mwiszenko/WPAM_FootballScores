//
//  AppView.swift
//  FootballScores
//
//  Created by Michal on 13/12/2020.
//

import SwiftUI

struct AppView: View {
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            FixturesView()
                .tabItem {
                    selection == 0 ? Image(systemName: "sportscourt.fill") : Image(systemName: "sportscourt")
                    Text("Fixtures")
                }
                .tag(0)

            LeaguesView()
                .tabItem {
                    Image(systemName: "note")
                    Text("Leagues")
                }
                .tag(1)

            FavouritesView()
                .tabItem {
                    selection == 2 ? Image(systemName: "star.fill") : Image(systemName: "star")
                    Text("Favourites")
                }
                .tag(2)

            SettingsView()
                .tabItem {
                    selection == 3 ? Image(systemName: "gearshape.fill") : Image(systemName: "gearshape")
                    Text("Settings")
                }
                .tag(3)
        }
    }
}

//struct AppView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppView()
//            .colorScheme(.dark)
//            .environmentObject(ModelData())
//            .environmentObject(Favourites())
//    }
//}
