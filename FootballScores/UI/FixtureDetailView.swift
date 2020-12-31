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
            HStack {
                RemoteImage(url: fixture.homeTeam.logo)
                    .aspectRatio(contentMode: .fit)
                    .imageScale(.small)
                RemoteImage(url: fixture.awayTeam.logo)
                    .aspectRatio(contentMode: .fit)
                    .imageScale(.small)
            }
            
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
        .navigationBarTitleDisplayMode(.inline)
    }
}
