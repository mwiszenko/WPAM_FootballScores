//
//  ModelData.swift
//  FootballScores
//
//  Created by Michal on 22/12/2020.
//

import Combine
import Foundation

final class ModelData: ObservableObject {
    typealias LeagueId = Int
    typealias FixtureId = Int
    typealias Country = String

    @Published var fixtures: [Fixture] = []
    @Published var fixturesDict: [FixtureLeague: [Fixture]] = [:]

    @Published var leagues: [League] = []
    @Published var leaguesDict: [Country: [League]] = [:]

    @Published var standingsDict: [LeagueId: [Standings]] = [:]

    @Published var statisticsDict: [FixtureId: [Statistics]] = [:]

    @Published var eventsDict: [FixtureId: [Event]] = [:]

    let season = 2020
    let date: String

    init() {
        let todayDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.date = dateFormatter.string(from: todayDate)
    }
    
    func fetchStandings(id: Int, completion: @escaping (([Standings]) -> Void)) {
        guard let url = URL(string: "https://v3.football.api-sports.io/standings?season=" + String(season) + "&league=" + String(id)) else {
            print("Your API end point is Invalid")
            return
        }
        var request = URLRequest(url: url)
        request.addValue("3e6a491054c4f9a0fd77f7bfc7540225", forHTTPHeaderField: "x-rapidapi-key")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            let standingsResponse = try! JSONDecoder().decode(StandingsResponse.self, from: data)
            DispatchQueue.main.async {
                completion(standingsResponse.response)
            }
        }.resume()
    }

    func loadEvents(id: Int) {
        guard let url = URL(string: "https://v3.football.api-sports.io/fixtures/events?fixture=" + String(id)) else {
            print("Your API end point is Invalid")
            return
        }
        var request = URLRequest(url: url)
        request.addValue("3e6a491054c4f9a0fd77f7bfc7540225", forHTTPHeaderField: "x-rapidapi-key")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            let eventsResponse = try! JSONDecoder().decode(EventsResponse.self, from: data)
            DispatchQueue.main.async {
                self.eventsDict.updateValue(eventsResponse.response, forKey: id)
            }
        }.resume()
    }

    func loadStatistics(id: Int) {
        guard let url = URL(string: "https://v3.football.api-sports.io/fixtures/statistics?fixture=" + String(id)) else {
            print("Your API end point is Invalid")
            return
        }
        var request = URLRequest(url: url)
        request.addValue("3e6a491054c4f9a0fd77f7bfc7540225", forHTTPHeaderField: "x-rapidapi-key")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            let statisticsResponse = try! JSONDecoder().decode(StatisticsResponse.self, from: data)
            DispatchQueue.main.async {
                self.statisticsDict.updateValue(statisticsResponse.response, forKey: id)
            }
        }.resume()
    }

    func loadStandings(id: Int) {
        guard let url = URL(string: "https://v3.football.api-sports.io/standings?season=" + String(season) + "&league=" + String(id)) else {
            print("Your API end point is Invalid")
            return
        }
        var request = URLRequest(url: url)
        request.addValue("3e6a491054c4f9a0fd77f7bfc7540225", forHTTPHeaderField: "x-rapidapi-key")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            let standingsResponse = try! JSONDecoder().decode(StandingsResponse.self, from: data)
            DispatchQueue.main.async {
                self.standingsDict.updateValue(standingsResponse.response, forKey: id)
            }
        }.resume()
    }

    func loadLeagues() {
        guard let url = URL(string: "https://v3.football.api-sports.io/leagues") else {
            print("Your API end point is Invalid")
            return
        }
        var request = URLRequest(url: url)
        request.addValue("3e6a491054c4f9a0fd77f7bfc7540225", forHTTPHeaderField: "x-rapidapi-key")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            let leaguesResponse = try! JSONDecoder().decode(LeaguesResponse.self, from: data)
            DispatchQueue.main.async {
                self.leagues = leaguesResponse.response
                self.leaguesDict = Dictionary(grouping: self.leagues, by: \.country)
            }
        }.resume()
    }

    func loadFixtures() {
        guard let url = URL(string: "https://v3.football.api-sports.io/fixtures?date=" + date) else {
            print("Your API end point is Invalid")
            return
        }
        var request = URLRequest(url: url)
        request.addValue("3e6a491054c4f9a0fd77f7bfc7540225", forHTTPHeaderField: "x-rapidapi-key")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            let fixturesResponse = try! JSONDecoder().decode(FixturesResponse.self, from: data)
            DispatchQueue.main.async {
                self.fixtures = fixturesResponse.response
                self.fixturesDict = Dictionary(grouping: self.fixtures, by: \.league)
            }
        }.resume()
    }

    static func loadData() -> [Standings] {
        if let url = Bundle.main.url(forResource: "standings", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let standingsResponse = try decoder.decode(StandingsResponse.self, from: data)
                return standingsResponse.response
            } catch {
                print("error:\(error)")
            }
        }
        return []
    }
}
