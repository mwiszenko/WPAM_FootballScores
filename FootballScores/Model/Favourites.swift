//
//  Favourites.swift
//  FootballScores
//
//  Created by Michal on 29/12/2020.
//

import Foundation

class Favourites: ObservableObject {
    private var leagues: Set<Int>

    private let saveKey = "Favourites"

    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode(Set<Int>.self, from: data) {
                self.leagues = decoded
                return
            }
        }

        self.leagues = []
    }

    func contains(_ id: Int) -> Bool {
        leagues.contains(id)
    }
    
    func containsAny(_ ids: [Int]) -> Bool {
        leagues.contains(where: ids.contains)
    }
    
    func isEmpty() -> Bool {
        leagues.isEmpty
    }
    

    func add(_ id: Int) {
        objectWillChange.send()
        leagues.insert(id)
        save()
    }

    func remove(_ id: Int) {
        objectWillChange.send()
        leagues.remove(id)
        save()
    }

    func save() {
        if let encoded = try? JSONEncoder().encode(leagues) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
}
