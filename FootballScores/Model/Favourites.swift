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
        // load our saved data

        // still here? Use an empty array
        self.leagues = []
    }

    // returns true if our set contains this resort
    func contains(_ id: Int) -> Bool {
        leagues.contains(id)
    }

    // adds the resort to our set, updates all views, and saves the change
    func add(_ id: Int) {
        objectWillChange.send()
        leagues.insert(id)
        save()
    }

    // removes the resort from our set, updates all views, and saves the change
    func remove(_ id: Int) {
        objectWillChange.send()
        leagues.remove(id)
        save()
    }

    func save() {
        // write out our data
    }
}
