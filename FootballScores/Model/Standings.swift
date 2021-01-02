//
//  Standings.swift
//  FootballScores
//
//  Created by Michal on 29/12/2020.
//

import Foundation

struct StandingsResponse: Decodable {
    let response: [Standings]
}

struct Standings: Identifiable {
    var id: Int

    let league: StandingsLeague
    let table: [[StandingsRow]]

    enum CodingKeys: String, CodingKey {
        case league
    }

    enum LeagueKeys: String, CodingKey {
        case table = "standings"
        case id
    }
}

extension Standings: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        league = try values.decode(StandingsLeague.self, forKey: .league)

        let league = try values.nestedContainer(keyedBy: LeagueKeys.self, forKey: .league)

        id = try league.decode(Int.self, forKey: .id)
        table = try league.decode([[StandingsRow]].self, forKey: .table)
    }
}

struct StandingsLeague: Identifiable, Decodable {
    let id: Int
    let name: String
    let logo: String
    let country: String
}

struct StandingsRow: Hashable, Decodable {
    let rank: Int
    let team: StandingsTeam
    let all: StandingsStatistics
    let home: StandingsStatistics
    let away: StandingsStatistics
}

struct StandingsTeam: Hashable, Decodable {
    let id: Int
    let name: String
    let logo: String
}

struct StandingsStatistics: Hashable {
    let played: Int
    let win: Int
    let draw: Int
    let lose: Int
    let goalsFor: Int
    let goalsAgainst: Int

    enum CodingKeys: String, CodingKey {
        case played
        case win
        case draw
        case lose
        case goals
    }

    enum GoalsKeys: String, CodingKey {
        case goalsFor = "against"
        case goalsAgainst = "for"
    }
}

extension StandingsStatistics: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        played = try values.decode(Int.self, forKey: .played)
        win = try values.decode(Int.self, forKey: .win)
        draw = try values.decode(Int.self, forKey: .draw)
        lose = try values.decode(Int.self, forKey: .lose)

        let goals = try values.nestedContainer(keyedBy: GoalsKeys.self, forKey: .goals)

        goalsFor = try goals.decode(Int.self, forKey: .goalsFor)
        goalsAgainst = try goals.decode(Int.self, forKey: .goalsAgainst)
    }
}
