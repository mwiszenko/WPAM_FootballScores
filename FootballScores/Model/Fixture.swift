//
//  Match.swift
//  FootballScores
//
//  Created by Michal on 13/12/2020.
//

import Foundation

struct FixturesResponse: Decodable {
    let response: [Fixture]
}

struct Fixture: Identifiable {
    
    let id: Int
    let referee: String?
    let date: Date
    let venue: Venue
    let homeTeam: Team
    let awayTeam: Team
    let homeGoals: Int?
    let awayGoals: Int?
    let league: FixtureLeague
    let status: FixtureStatus
    
    enum CodingKeys: String, CodingKey {
        case fixture
        case league
        case teams
        case goals
    }
    
    enum FixtureKeys: String, CodingKey {
        case id
        case referee
        case timestamp
        case venue
        case status
    }
    
    enum TeamsKeys: String, CodingKey {
        case home
        case away
    }
    
    enum GoalsKeys: String, CodingKey {
        case home
        case away
    }
}

struct FixtureLeague: Decodable, Hashable {
    
    let id: Int
    let name: String
    let logo: String
    let country: String
    
}

extension Fixture: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        league = try values.decode(FixtureLeague.self, forKey: .league)
        
        let fixture = try values.nestedContainer(keyedBy: FixtureKeys.self, forKey: .fixture)
        id = try fixture.decode(Int.self, forKey: .id)
        referee = try fixture.decode(String?.self, forKey: .referee)
        let timestamp = try fixture.decode(TimeInterval.self, forKey: .timestamp)
        date = Date(timeIntervalSince1970: timestamp)
        venue = try fixture.decode(Venue.self, forKey: .venue)
        status = try fixture.decode(FixtureStatus.self, forKey: .status)

        let teams = try values.nestedContainer(keyedBy: TeamsKeys.self, forKey: .teams)
        homeTeam = try teams.decode(Team.self, forKey: .home)
        awayTeam = try teams.decode(Team.self, forKey: .away)

        let goals = try values.nestedContainer(keyedBy: GoalsKeys.self, forKey: .goals)
        homeGoals = try goals.decode(Int?.self, forKey: .home)
        awayGoals = try goals.decode(Int?.self, forKey: .away)
    }
}
