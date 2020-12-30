//
//  MatchDetailView.swift
//  FootballScores
//
//  Created by Michal on 22/12/2020.
//

import SwiftUI

struct FixtureDetailView: View {
    @EnvironmentObject var modelData: ModelData
    var fixture: Fixture

    var fixtureIndex: Int {
        modelData.fixtures.firstIndex(where: { $0.id == fixture.id })!
    }

    var body: some View {
        VStack {
            Text("\(fixture.id)")
            Text(fixture.homeTeam.logo)
        }
    }
}
