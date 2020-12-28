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
            Text(fixture.homeTeam.name)
            Spacer()
            RemoteImage(url: fixture.homeTeam.logo)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
            Spacer()
            if fixture.homeGoals != nil && fixture.awayGoals != nil {
                Text("\(fixture.homeGoals ?? 0) - \(fixture.homeGoals ?? 0)")
            } else {
                Text(fixture.date.addingTimeInterval(600), style: .time)
            }
            Spacer()
            RemoteImage(url: fixture.awayTeam.logo)
                        .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
            Spacer()
            Text(fixture.awayTeam.name)
        }
    }
}

struct FixtureRowView_Previews: PreviewProvider {
    static var fixtures = ModelData().fixtures
    
    static var previews: some View {
        FixtureRowView(fixture: fixtures[0])
    }
}
