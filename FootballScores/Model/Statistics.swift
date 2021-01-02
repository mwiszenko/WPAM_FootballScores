//
//  Statistics.swift
//  FootballScores
//
//  Created by Michal on 31/12/2020.
//

import Foundation

struct StatisticsResponse: Decodable {
    let response: [Statistics]
}

struct Statistics: Hashable {
    let teamId: Int
    let teamName: String
    let teamLogo: String
    
    let stats: [SingleStatistic]
    
    enum CodingKeys: String, CodingKey {
        case team
        case statistics
    }
    
    enum TeamKeys: String, CodingKey {
        case teamId = "id"
        case teamName = "name"
        case teamLogo = "logo"
    }
}

extension Statistics: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        stats = try values.decode([SingleStatistic].self, forKey: .statistics)
        
        let team = try values.nestedContainer(keyedBy: TeamKeys.self, forKey: .team)
        
        teamId = try team.decode(Int.self, forKey: .teamId)
        teamName = try team.decode(String.self, forKey: .teamName)
        teamLogo = try team.decode(String.self, forKey: .teamLogo)
    }
}

struct SingleStatistic: Hashable, Decodable {
    let type: String
    let value: String?
    
    enum CodingKeys: String, CodingKey {
        case type
        case value
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try values.decode(String.self, forKey: .type)

        do {
            value = try values.decode(String?.self, forKey: .value)
        } catch DecodingError.typeMismatch {
            value = try String(values.decode(Int.self, forKey: .value))
        }
    }
}
