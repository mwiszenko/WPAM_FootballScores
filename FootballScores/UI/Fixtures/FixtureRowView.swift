//
//  FixtureRowView.swift
//  FootballScores
//
//  Created by Michal on 22/12/2020.
//

import SwiftUI

struct FixtureRowView: View {
    var fixture: Fixture

    var body: some View {
        HStack {
            home
            score
            away
        }
    }
}

// MARK: -

private extension FixtureRowView {
    var home: some View {
        HStack {
            Spacer()
            Text(fixture.homeTeam.name)
                .font(.system(size: 12))
                .multilineTextAlignment(.trailing)
            RemoteImage(url: fixture.homeTeam.logo)
                .frame(width: 20, height: 20)
        }
    }

    var away: some View {
        HStack {
            RemoteImage(url: fixture.awayTeam.logo)
                .frame(width: 20, height: 20)
            Text(fixture.awayTeam.name)
                .font(.system(size: 12))
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }

    @ViewBuilder
    var score: some View {
        if fixture.homeGoals != nil && fixture.awayGoals != nil {
            Text("\(fixture.homeGoals ?? 0) - \(fixture.homeGoals ?? 0)")
                .font(.system(size: 12))
        } else {
            Text(fixture.date.addingTimeInterval(600), style: .time)
                .font(.system(size: 12))
        }
    }
}
