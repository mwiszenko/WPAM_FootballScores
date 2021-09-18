//
//  TableRowView.swift
//  FootballScores
//
//  Created by Michal on 30/12/2020.
//

import SwiftUI

struct TableRowView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var favourites: Favourites

    var row: StandingsRow
    var type: String

    var body: some View {
        HStack{
            HStack {
                Text("20")
//                    .hidden()
//                    .overlay(Text("\(row.rank)"))
//                RemoteImage(url: row.team.logo)
//                    .frame(width: 20, height: 20)
//                Text("\(row.team.name)")
//            }
//            Spacer()
//            if type == "ALL" {
//                stats(row: row.all)
//            } else if type == "HOME" {
//                stats(row: row.home)
//            } else if type == "AWAY" {
//                stats(row: row.away)
            }
        }
    }
}

// MARK: - Statistics

extension TableRowView {
    func stats(row: StandingsStatistics) -> some View {
        Group {
            Text("00")
                .hidden()
                .overlay(Text("\(row.played ?? 0)"))
            Text("00")
                .hidden()
                .overlay(Text("\(row.win ?? 0)"))
            Text("00")
                .hidden()
                .overlay(Text("\(row.draw ?? 0)"))
            Text("00")
                .hidden()
                .overlay(Text("\(row.lose ?? 0)"))
            Text("GF")
                .hidden()
                .overlay(Text("\(row.goalsFor ?? 0)"))
            Text("GA")
                .hidden()
                .overlay(Text("\(row.goalsAgainst ?? 0)"))
            Text("PT")
                .hidden()
                .overlay(Text("\(3 * (row.win ?? 0) + (row.draw ?? 0))"))
        }
    }
}
