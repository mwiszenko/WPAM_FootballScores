//
//  League.swift
//  FootballScores
//
//  Created by Michal on 13/12/2020.
//

import Foundation

struct LeaguesResponse: Decodable {
    let response: [League]
}

struct League: Hashable, Identifiable {
    
    let id: Int
    let name: String
    let logo: String
    let country: String
    let flag: String?
    
    enum CodingKeys: String, CodingKey {
        case league
        case country
    }
    
    enum LeagueKeys: String, CodingKey {
        case id
        case name
        case logo
    }
    
    enum CountryKeys: String, CodingKey {
        case country = "name"
        case flag
    }
}

extension League: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let league = try values.nestedContainer(keyedBy: LeagueKeys.self, forKey: .league)
        id = try league.decode(Int.self, forKey: .id)
        name = try league.decode(String.self, forKey: .name)
        logo = try league.decode(String.self, forKey: .logo)
        
        let country = try values.nestedContainer(keyedBy: CountryKeys.self, forKey: .country)
        self.country = try country.decode(String.self, forKey: .country)
        flag = try country.decode(String?.self, forKey: .flag)
    }
}
