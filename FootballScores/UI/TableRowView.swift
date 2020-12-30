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
                .frame(width: 20, height: 20)
            Text(row.team.name)
            if type == "ALL" {
                TableRowStatsView(row: row.all)
            } else if type == "HOME" {
                TableRowStatsView(row: row.home)
            } else if type == "AWAY" {
                TableRowStatsView(row: row.away)
            }
        }
        .font(.system(size: 12))
    }
}

struct TableRowStatsView: View {
    var row: StandingsStatistics
    
    var body: some View {
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
