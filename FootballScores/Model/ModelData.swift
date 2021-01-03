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

    @Published var standings: [Standings] = []
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
//            if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
//                                                                in: .userDomainMask).first {
//                let pathWithFileName = documentDirectory.appendingPathComponent("events").appendingPathExtension("json")
//                try! data.write(to: pathWithFileName)
//                print(pathWithFileName)
//            }
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
//            if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
//                                                                in: .userDomainMask).first {
//                let pathWithFileName = documentDirectory.appendingPathComponent("statistics").appendingPathExtension("json")
//                try! data.write(to: pathWithFileName)
//                print(pathWithFileName)
//            }
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
//            if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
//                                                                in: .userDomainMask).first {
//                let pathWithFileName = documentDirectory.appendingPathComponent("standings").appendingPathExtension("json")
//                try! data.write(to: pathWithFileName)
//            }
            let standingsResponse = try! JSONDecoder().decode(StandingsResponse.self, from: data)
            DispatchQueue.main.async {
                self.standings.append(contentsOf: standingsResponse.response)
                self.standingsDict = Dictionary(grouping: self.standings, by: \.id)
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
//            if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
//                                                                in: .userDomainMask).first {
//                let pathWithFileName = documentDirectory.appendingPathComponent("leagues").appendingPathExtension("json")
//                try! data.write(to: pathWithFileName)
//            }
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
//            if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
//                                                                in: .userDomainMask).first {
//                let pathWithFileName = documentDirectory.appendingPathComponent("fixtures").appendingPathExtension("json")
//                try! data.write(to: pathWithFileName)
//            }
            let fixturesResponse = try! JSONDecoder().decode(FixturesResponse.self, from: data)
            DispatchQueue.main.async {
                self.fixtures = fixturesResponse.response
                self.fixturesDict = Dictionary(grouping: self.fixtures, by: \.league)
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
                self.fixturesDict = Dictionary(grouping: self.fixtures, by: \.league)
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
                self.leaguesDict = Dictionary(grouping: self.leagues, by: \.country)
            } catch {
                print("error:\(error)")
            }
        }

        if let url = Bundle.main.url(forResource: "standings", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let standingsResponse = try decoder.decode(StandingsResponse.self, from: data)
                self.standings.append(contentsOf: standingsResponse.response)
                self.standingsDict = Dictionary(grouping: self.standings, by: \.id)
            } catch {
                print("error:\(error)")
            }
        }

        if let url = Bundle.main.url(forResource: "statistics", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let statisticsResponse = try! decoder.decode(StatisticsResponse.self, from: data)
                self.statisticsDict.updateValue(statisticsResponse.response, forKey: 526699)
            } catch {
                print("error:\(error)")
            }
        }

        if let url = Bundle.main.url(forResource: "events", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let eventsResponse = try! decoder.decode(EventsResponse.self, from: data)
                self.eventsDict.updateValue(eventsResponse.response, forKey: 526699)
            } catch {
                print("error:\(error)")
            }
        }
    }
}
