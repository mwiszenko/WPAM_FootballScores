//
//  Venue.swift
//  FootballScores
//
//  Created by Michal on 27/12/2020.
//

import Foundation

struct Venue: Hashable, Codable, Identifiable {
    
    let id: Int
    let name: String
    let city: String
}
