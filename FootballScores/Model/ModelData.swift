//
//  ModelData.swift
//  FootballScores
//
//  Created by Michal on 22/12/2020.
//

import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var fixtures: [Fixture] = [Fixture]()
    @Published var leagues: [League] = [League]()
    
    func loadLeagues() {
        guard let url = URL(string: "https://v3.football.api-sports.io/leagues") else {
            print("Your API end point is Invalid")
            return
        }
        var request = URLRequest(url: url)
        request.addValue("3e6a491054c4f9a0fd77f7bfc7540225", forHTTPHeaderField: "x-rapidapi-key")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
                let leaguesResponse = try! JSONDecoder().decode(LeaguesResponse.self, from: data)
                DispatchQueue.main.async {
                    self.leagues = leaguesResponse.response
                }
        }.resume()
    }
    
    func loadFixtures() {
        guard let url = URL(string: "https://v3.football.api-sports.io/fixtures") else {
            print("Your API end point is Invalid")
            return
        }
        var request = URLRequest(url: url)
        request.addValue("3e6a491054c4f9a0fd77f7bfc7540225", forHTTPHeaderField: "x-rapidapi-key")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
                let fixturesResponse = try! JSONDecoder().decode(FixturesResponse.self, from: data)
                DispatchQueue.main.async {
                    self.fixtures = fixturesResponse.response
                }
        }.resume()
    }
}
