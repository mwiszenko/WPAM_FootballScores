//
//  MatchRowView.swift
//  FootballScores
//
//  Created by Michal on 22/12/2020.
//

import SwiftUI

struct FixtureRowView: View {
    var fixture: Fixture

    var body: some View {
        HStack {
            Text(fixture.referee)
        }
    }
}

struct FixtureRowView_Previews: PreviewProvider {
    static var fixtures = ModelData().fixtures
    
    static var previews: some View {
        FixtureRowView(fixture: fixtures[0])
    }
}
