//
//  Status.swift
//  FootballScores
//
//  Created by Michal on 14/09/2021.
//

import Foundation

struct StatusResponse: Decodable {
    let response: Status
}

struct Status {
    let usedRequests: Int
    let maxRequests: Int
    
    enum CodingKeys: String, CodingKey {
        case requests
    }
    
    enum RequestsKeys: String, CodingKey {
        case current
        case limit_day
    }
}

extension Status: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        let requests = try values.nestedContainer(keyedBy: RequestsKeys.self, forKey: .requests)
        usedRequests = try requests.decode(Int.self, forKey: .current)
        maxRequests = try requests.decode(Int.self, forKey: .limit_day)
    }
}
