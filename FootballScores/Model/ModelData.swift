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
    
    @Published var requestsStatus: Status = Status(usedRequests: 0, maxRequests: 100)
    
    let apiHeaderField: String = "x-rapidapi-key"
    let season: Int = 2021
    let date: String

    init() {
        let todayDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.date = dateFormatter.string(from: todayDate)
    }
    
    func fetchStatus() {
        guard let url = URL(string: "https://v3.football.api-sports.io/status") else {
            print("Your API end point is Invalid")
            return
        }
        var request = URLRequest(url: url)
        request.addValue(UserPreferences().apiKey, forHTTPHeaderField: apiHeaderField)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            let statusResponse = try! JSONDecoder().decode(StatusResponse.self, from: data)
            DispatchQueue.main.async {
                self.requestsStatus = statusResponse.response
            }
        }.resume()
    }
    
    func fetchStandings(id: Int, completion: @escaping (([Standings]) -> Void)) {
        guard let url = URL(string: "https://v3.football.api-sports.io/standings?season=" + String(season) + "&league=" + String(id)) else {
            print("Your API end point is Invalid")
            return
        }
        var request = URLRequest(url: url)
        request.addValue(UserPreferences().apiKey, forHTTPHeaderField: apiHeaderField)

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
        request.addValue(UserPreferences().apiKey, forHTTPHeaderField: apiHeaderField)

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
        request.addValue(UserPreferences().apiKey, forHTTPHeaderField: apiHeaderField)

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
        request.addValue(UserPreferences().apiKey, forHTTPHeaderField: apiHeaderField)

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
        request.addValue(UserPreferences().apiKey, forHTTPHeaderField: apiHeaderField)

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
        request.addValue(UserPreferences().apiKey, forHTTPHeaderField: apiHeaderField)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            let fixturesResponse = try! JSONDecoder().decode(FixturesResponse.self, from: data)
            DispatchQueue.main.async {
                self.fixtures = fixturesResponse.response
                self.fixturesDict = Dictionary(grouping: self.fixtures, by: \.league)
            }
        }.resume()
    }

    static func getPlaceholderStandings() -> [Standings] {
        [Standings(id: 39, league: StandingsLeague(id: 39, name: "Premier League", logo: "https://media.api-sports.io/football/leagues/39.png", country: "England"), table: [[
            StandingsRow(rank: 1, points: 32, team: StandingsTeam(id: 40, name: "Liverpool", logo: "https://media.api-sports.io/football/teams/40.png"), all: StandingsStatistics(played: 15, win: 9, draw: 5, lose: 1, goalsFor: 37, goalsAgainst: 20), home: StandingsStatistics(played: 8, win: 7, draw: 1, lose: 0, goalsFor: 21, goalsAgainst: 8), away: StandingsStatistics(played: 7, win: 2, draw: 4, lose: 1, goalsFor: 16, goalsAgainst: 12)),
            StandingsRow(rank: 2, points: 29, team: StandingsTeam(id: 46, name: "Leicester", logo: "https://media.api-sports.io/football/teams/46.png"), all: StandingsStatistics(played: 16, win: 9, draw: 2, lose: 5, goalsFor: 29, goalsAgainst: 20), home: StandingsStatistics(played: 8, win: 3, draw: 1, lose: 4, goalsFor: 11, goalsAgainst: 12), away: StandingsStatistics(played: 8, win: 6, draw: 1, lose: 1, goalsFor: 18, goalsAgainst: 8)),
            StandingsRow(rank: 3, points: 29, team: StandingsTeam(id: 45, name: "Everton", logo: "https://media.api-sports.io/football/teams/45.png"), all: StandingsStatistics(played: 15, win: 9, draw: 2, lose: 4, goalsFor: 26, goalsAgainst: 19), home: StandingsStatistics(played: 7, win: 4, draw: 1, lose: 2, goalsFor: 15, goalsAgainst: 11), away: StandingsStatistics(played: 8, win: 5, draw: 1, lose: 2, goalsFor: 11, goalsAgainst: 8)),
            StandingsRow(rank: 4, points: 27, team: StandingsTeam(id: 33, name: "Manchester United", logo: "https://media.api-sports.io/football/teams/33.png"), all: StandingsStatistics(played: 14, win: 8, draw: 3, lose: 3, goalsFor: 30, goalsAgainst: 23), home: StandingsStatistics(played: 7, win: 2, draw: 2, lose: 3, goalsFor: 9, goalsAgainst: 12), away: StandingsStatistics(played: 7, win: 6, draw: 1, lose: 0, goalsFor: 21, goalsAgainst: 11)),
            StandingsRow(rank: 5, points: 26, team: StandingsTeam(id: 66, name: "Aston Villa", logo: "https://media.api-sports.io/football/teams/66.png"), all: StandingsStatistics(played: 14, win: 8, draw: 2, lose: 4, goalsFor: 28, goalsAgainst: 14), home: StandingsStatistics(played: 7, win: 3, draw: 1, lose: 3, goalsFor: 15, goalsAgainst: 11), away: StandingsStatistics(played: 7, win: 5, draw: 1, lose: 1, goalsFor: 13, goalsAgainst: 3)),
            StandingsRow(rank: 6, points: 26, team: StandingsTeam(id: 49, name: "Chelsea", logo: "https://media.api-sports.io/football/teams/49.png"), all: StandingsStatistics(played: 16, win: 7, draw: 5, lose: 4, goalsFor: 31, goalsAgainst: 18), home: StandingsStatistics(played: 8, win: 4, draw: 3, lose: 1, goalsFor: 18, goalsAgainst: 8), away: StandingsStatistics(played: 8, win: 3, draw: 2, lose: 3, goalsFor: 13, goalsAgainst: 10)),
            StandingsRow(rank: 7, points: 26, team: StandingsTeam(id: 47, name: "Tottenham", logo: "https://media.api-sports.io/football/teams/47.png"), all: StandingsStatistics(played: 15, win: 7, draw: 5, lose: 3, goalsFor: 26, goalsAgainst: 15), home: StandingsStatistics(played: 7, win: 3, draw: 2, lose: 2, goalsFor: 10, goalsAgainst: 8), away: StandingsStatistics(played: 8, win: 4, draw: 3, lose: 1, goalsFor: 16, goalsAgainst: 7)),
            StandingsRow(rank: 8, points: 26, team: StandingsTeam(id: 50, name: "Manchester City", logo: "https://media.api-sports.io/football/teams/50.png"), all: StandingsStatistics(played: 14, win: 7, draw: 5, lose: 2, goalsFor: 21, goalsAgainst: 12), home: StandingsStatistics(played: 7, win: 4, draw: 2, lose: 1, goalsFor: 14, goalsAgainst: 7), away: StandingsStatistics(played: 7, win: 3, draw: 3, lose: 1, goalsFor: 7, goalsAgainst: 5)),
            StandingsRow(rank: 9, points: 26, team: StandingsTeam(id: 41, name: "Southampton", logo: "https://media.api-sports.io/football/teams/41.png"), all: StandingsStatistics(played: 16, win: 7, draw: 5, lose: 4, goalsFor: 25, goalsAgainst: 19), home: StandingsStatistics(played: 8, win: 4, draw: 1, lose: 3, goalsFor: 13, goalsAgainst: 9), away: StandingsStatistics(played: 8, win: 3, draw: 4, lose: 1, goalsFor: 12, goalsAgainst: 10)),
            StandingsRow(rank: 10, points: 23, team: StandingsTeam(id: 48, name: "West Ham", logo: "https://media.api-sports.io/football/teams/48.png"), all: StandingsStatistics(played: 16, win: 6, draw: 5, lose: 5, goalsFor: 23, goalsAgainst: 21), home: StandingsStatistics(played: 8, win: 3, draw: 3, lose: 2, goalsFor: 12, goalsAgainst: 10), away: StandingsStatistics(played: 8, win: 3, draw: 2, lose: 3, goalsFor: 11, goalsAgainst: 11)),
        ]])]
    }
}
