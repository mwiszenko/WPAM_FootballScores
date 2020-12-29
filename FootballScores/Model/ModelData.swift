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
    @Published var fixturesDict: [FixtureLeague: [Fixture]] = [FixtureLeague: [Fixture]]()
    @Published var leaguesDict: [String: [League]] = [String: [League]]()

    
    init() {
        loadData()
    }
    
    func loadLeagues() {
        guard let url = URL(string: "https://v3.football.api-sports.io/leagues") else {
            print("Your API end point is Invalid")
            return
        }
        var request = URLRequest(url: url)
        request.addValue("3e6a491054c4f9a0fd77f7bfc7540225", forHTTPHeaderField: "x-rapidapi-key")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first {
                let pathWithFileName = documentDirectory.appendingPathComponent("leagues").appendingPathExtension("json")
                print(pathWithFileName)
                try! data.write(to: pathWithFileName)
            }
                let leaguesResponse = try! JSONDecoder().decode(LeaguesResponse.self, from: data)
                DispatchQueue.main.async {
                    self.leagues = leaguesResponse.response
                }
        }.resume()
    }
    
    func loadFixtures() {
        guard let url = URL(string: "https://v3.football.api-sports.io/fixtures?date=2020-12-28") else {
            print("Your API end point is Invalid")
            return
        }
        var request = URLRequest(url: url)
        request.addValue("3e6a491054c4f9a0fd77f7bfc7540225", forHTTPHeaderField: "x-rapidapi-key")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first {
                let pathWithFileName = documentDirectory.appendingPathComponent("fixtures").appendingPathExtension("json")
                print(pathWithFileName)
                try! data.write(to: pathWithFileName)
            }
            let fixturesResponse = try! JSONDecoder().decode(FixturesResponse.self, from: data)
                DispatchQueue.main.async {
                    self.fixtures = fixturesResponse.response
                }
        }.resume()
    }
    
    func loadData() {
        if let url = Bundle.main.url(forResource: "fixtures", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let fixturesResponse = try decoder.decode(FixturesResponse.self, from: data)
                self.fixtures = fixturesResponse.response
                self.fixturesDict = Dictionary(grouping: fixtures, by: \.league)
            } catch {
                print("error:\(error)")
            }
        }
        
        if let url = Bundle.main.url(forResource: "leagues", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let leaguesResponse = try decoder.decode(LeaguesResponse.self, from: data)
                self.leagues = leaguesResponse.response
                self.leaguesDict = Dictionary(grouping: leagues, by: \.country)
            } catch {
                print("error:\(error)")
            }
        }
    }
}
