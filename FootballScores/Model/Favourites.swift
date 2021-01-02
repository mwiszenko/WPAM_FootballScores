//
//  Favourites.swift
//  FootballScores
//
//  Created by Michal on 29/12/2020.
//

import Foundation

class Favourites: ObservableObject {
    @Published var leagues: [Int]

    private let saveKey = "Favourites"

    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([Int].self, from: data) {
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
    
    func move(source: IndexSet, destination: Int) {
        leagues.move(fromOffsets: source, toOffset: destination)
        save()
    }
    

    func add(_ id: Int) {
        if (leagues.firstIndex(of: id) == nil) {
            objectWillChange.send()
            leagues.append(id)
            save()
        }
    }

    func remove(_ id: Int) {
        if let index = leagues.firstIndex(of: id) {
            objectWillChange.send()
            leagues.remove(at: index)
            save()
        }
    }

    func save() {
        if let encoded = try? JSONEncoder().encode(leagues) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
}
