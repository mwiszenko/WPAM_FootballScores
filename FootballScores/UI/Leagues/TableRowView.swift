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

    let columns = [
        GridItem(.fixed(15)),
        GridItem(.fixed(20)),
        GridItem(.flexible()),
        GridItem(.fixed(15)),
        GridItem(.fixed(15)),
        GridItem(.fixed(15)),
        GridItem(.fixed(15)),
        GridItem(.fixed(15)),
        GridItem(.fixed(15)),
        GridItem(.fixed(15)),
    ]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading) {
            Text("\(row.rank)")
            RemoteImage(url: row.team.logo)
                .aspectRatio(contentMode: .fit)
            Text(row.team.name)
            if type == "ALL" {
                stats(row: row.all)
            } else if type == "HOME" {
                stats(row: row.home)
            } else if type == "AWAY" {
                stats(row: row.away)
            }
        }
        .font(.caption)
    }
}

// MARK: - Statistics

extension TableRowView {
    func stats(row: StandingsStatistics) -> some View {
        Group {
            Text("\(row.played)")
            Text("\(row.win)")
            Text("\(row.draw)")
            Text("\(row.lose)")
            Text("\(row.goalsFor)")
            Text("\(row.goalsAgainst)")
            Text("\(row.win * 3 + row.draw)")
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}
