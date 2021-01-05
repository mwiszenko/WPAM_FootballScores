//
//  FixtureRowView.swift
//  FootballScores
//
//  Created by Michal on 22/12/2020.
//

import SwiftUI

struct FixtureRowView: View {
    var fixture: Fixture

    let showElapsed: [String] = ["1H", "2H", "ET"]

    let showStatus: [String] = ["NS", "FT", "HT", "AET", "PEN", "BT", "SUSP", "INT", "PST", "CANC", "ABD", "AWD", "WO"]

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
                .font(.footnote)
                .multilineTextAlignment(.trailing)
            RemoteImage(url: fixture.homeTeam.logo)
                .frame(width: 25, height: 25)
        }
    }

    var away: some View {
        HStack {
            RemoteImage(url: fixture.awayTeam.logo)
                .frame(width: 25, height: 25)
            Text(fixture.awayTeam.name)
                .font(.footnote)
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }

    @ViewBuilder
    var score: some View {
        VStack {
            if fixture.homeGoals != nil && fixture.awayGoals != nil {
                Text("10 - 10")
                    .hidden()
                    .overlay(Text("\(fixture.homeGoals ?? 0) - \(fixture.awayGoals ?? 0)"))
            } else {
                Text(fixture.date.addingTimeInterval(600), style: .time)
            }

            if showElapsed.contains(fixture.status.short) {
                Text("10 - 10")
                    .hidden()
                    .overlay(Text("\(fixture.status.elapsed ?? 0)" + "'")
                        .foregroundColor(.green))
            } else {
                Text(fixture.status.short)
            }
        }
        .font(.footnote)
    }
}
