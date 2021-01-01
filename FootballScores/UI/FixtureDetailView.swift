//
//  FixtureDetailView.swift
//  FootballScores
//
//  Created by Michal on 22/12/2020.
//

import SwiftUI

struct FixtureDetailView: View {
    @EnvironmentObject var modelData: ModelData
    var fixture: Fixture

    var body: some View {
        VStack {
            header
            
            events
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension FixtureDetailView {
    var header: some View {
        HStack {
            Spacer()
            RemoteImage(url: fixture.homeTeam.logo)
                .frame(width: 50, height: 50)
            if fixture.homeGoals != nil && fixture.awayGoals != nil {
                Text("\(fixture.homeGoals ?? 0) - \(fixture.homeGoals ?? 0)")
            } else {
                Text(fixture.date.addingTimeInterval(600), style: .time)
            }
            RemoteImage(url: fixture.awayTeam.logo)
                .frame(width: 50, height: 50)
            Spacer()
        }
    }
    
    var events: some View {
        ForEach(modelData.eventsDict.sorted { (first, second) -> Bool in
            return first.key < second.key
        }, id: \.key) { key, value in
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(value, id: \.self) { event in
                        VStack {
                            Text(event.type)
                            Text(event.playerName)
                            Text("\(event.elapsed)")
                        }
                    }
                }
            }
            .padding()
        }
    }
    
//    var statistics: some View {
//    }
}
