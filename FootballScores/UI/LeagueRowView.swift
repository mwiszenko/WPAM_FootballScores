//
//  LeagueRowView.swift
//  FootballScores
//
//  Created by Michal on 27/12/2020.
//

import SwiftUI

struct LeagueRowView: View {
    var league: League

    var body: some View {
        HStack {
            Text(league.name)
        }
    }
}

struct LeagueRowView_Previews: PreviewProvider {
    static var leagues = ModelData().leagues

    static var previews: some View {
        LeagueRowView(league: leagues[0])
    }
}
