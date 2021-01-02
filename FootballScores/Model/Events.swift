//
//  Events.swift
//  FootballScores
//
//  Created by Michal on 31/12/2020.
//

import Foundation

struct EventsResponse: Decodable {
    let response: [Event]
}

struct Event: Hashable, Decodable {
    let teamId: Int
    let teamName: String
    let teamLogo: String
    let elapsed: Int
    let playerName: String?
    let type: String
    let detail: String
    
    enum CodingKeys: String, CodingKey {
        case time
        case team
        case player
        case type
        case detail
    }
    
    enum TimeKeys: String, CodingKey {
        case elapsed
    }
    
    enum TeamKeys: String, CodingKey {
        case teamId = "id"
        case teamName = "name"
        case teamLogo = "logo"
    }
    
    enum PlayerKeys: String, CodingKey {
        case playerName = "name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try values.decode(String.self, forKey: .type)
        detail = try values.decode(String.self, forKey: .detail)

        let time = try values.nestedContainer(keyedBy: TimeKeys.self, forKey: .time)
        elapsed = try time.decode(Int.self, forKey: .elapsed)

        let team = try values.nestedContainer(keyedBy: TeamKeys.self, forKey: .team)
        teamId = try team.decode(Int.self, forKey: .teamId)
        teamName = try team.decode(String.self, forKey: .teamName)
        teamLogo = try team.decode(String.self, forKey: .teamLogo)

        let player = try values.nestedContainer(keyedBy: PlayerKeys.self, forKey: .player)
        playerName = try player.decode(String?.self, forKey: .playerName)
    }
}
