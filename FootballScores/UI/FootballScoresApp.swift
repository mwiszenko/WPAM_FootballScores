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

    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(modelData)
                .onAppear(perform: {
                    modelData.loadLeagues()
                    modelData.loadFixtures()
                })
        }
    }
}
