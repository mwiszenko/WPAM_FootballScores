//
//  FixturesView.swift
//  FootballScores
//
//  Created by Michal on 13/12/2020.
//

import SwiftUI

struct FixturesView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var favourites: Favourites

    @State private var searchPhrase: String = ""

    var searchedFixtures: [FixtureLeague: [Fixture]] {
        modelData.fixturesDict
            .filter { if searchPhrase != "" {
                return $0.key.name.localizedCaseInsensitiveContains(searchPhrase) || $0.key.country.localizedCaseInsensitiveContains(searchPhrase)
            } else {
                return true
            }
            }
    }

    var body: some View {
        VStack {
            NavigationView {
                if !modelData.fixtures.isEmpty {
                    List {
                        searchBar

                        ForEach(searchedFixtures.sorted { (first, second) -> Bool in
                            first.key.country < second.key.country
                        }, id: \.key) { league, fixtureList in
                            leagueSection(key: league, value: fixtureList)
                        }
                    }
                    .navigationTitle("Fixtures")
                    .listStyle(InsetGroupedListStyle())
                } else {
                    ProgressView("Loading")
                }
            }
        }
    }
}

// MARK: - Search bar

private extension FixturesView {
    var searchBar: some View {
        Section(header: Text("Search by league or country")) {
            HStack {
                TextField("Enter search criteria...", text: $searchPhrase)
                    .background(Color.clear)
                if searchPhrase == "" {
                    Image(systemName: "magnifyingglass")
                } else {
                    Button(action: {
                        searchPhrase = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(.primary)
                }
            }
        }
    }
}

// MARK: - League section with fixtures as rows

private extension FixturesView {
    func leagueSection(key: FixtureLeague, value: [Fixture]) -> some View {
        return Section(header: Text(key.country + " - " + key.name)) {
            ForEach(value) { fixture in
                NavigationLink(destination: FixtureDetailView(fixture: fixture)
                    .onAppear(perform: {
                        if modelData.eventsDict[fixture.id] == nil {
                            modelData.loadEvents(id: fixture.id)
                        }
                        if modelData.statisticsDict[fixture.id] == nil {
                            modelData.loadStatistics(id: fixture.id)
                        }
                    })
                ) {
                    FixtureRowView(fixture: fixture)
                }
            }
        }
    }
}
