//
//  FixtureStatus.swift
//  FootballScores
//
//  Created by Michal on 22/12/2020.
//

import Foundation

struct FixtureStatus: Hashable, Codable {
    
    let long: String
    let short: String
    let elapsed: Int
}
