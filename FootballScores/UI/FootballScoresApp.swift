//
//  FootballScoresApp.swift
//  FootballScores
//
//  Created by Michal on 01/12/2020.
//

import SwiftUI

@main
struct FootballScoresApp: App {
    @StateObject private var modelData = ModelData()
    @StateObject private var favourites = Favourites()
    @StateObject private var userPreferences = UserPreferences()

    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(modelData)
                .environmentObject(favourites)
                .environmentObject(userPreferences)
                .onAppear(perform: {
                    modelData.loadLeagues()
                    modelData.loadFixtures()
                    modelData.fetchStatus()
                })
        }
    }
}
