//
//  Team.swift
//  FootballScores
//
//  Created by Michal on 13/12/2020.
//

import Foundation

struct Team: Hashable, Codable, Identifiable {
    let id: Int
    let name: String
    let logo: String
    let winner: Bool?
}
