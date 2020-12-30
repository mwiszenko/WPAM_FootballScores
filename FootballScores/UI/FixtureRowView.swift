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
        VStack {
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
}
