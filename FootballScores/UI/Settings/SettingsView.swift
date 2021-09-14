//
//  SettingsView.swift
//  FootballScores
//
//  Created by Michal on 13/12/2020.
//

import StoreKit
import SwiftUI

struct SettingsView: View {
    @State var showAbout = false
    @EnvironmentObject var userPreferences: UserPreferences

    var body: some View {
        NavigationView {
            Form {
                widgetPreferencesSection
                apiSettingsSection
                feedbackSection
                aboutSection
            }
            .navigationTitle("Settings")
            .fullScreenCover(isPresented: $showAbout) {
                creditsPopup
            }
        }
    }
}

private extension SettingsView {
    var widgetPreferencesSection: some View {
        Section(header: Text("Widget preferences")) {
            DatePicker("Refresh time", selection: $userPreferences.widgetRefreshTime, displayedComponents: .hourAndMinute)
        }
    }
    
    var apiSettingsSection: some View {
        Section(header: Text("Api key")) {
            TextField("Enter api key", text: $userPreferences.apiKey)
        }
    }
    
    var feedbackSection: some View {
        Section(header: Text("Feedback")) {
            Button(action: {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            }) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("Rate us")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .imageScale(.small)
                        .font(Font.body.weight(.semibold))
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    var aboutSection: some View {
        Section {
            Button(action: {
                showAbout = true
            }) {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.primary)
                    Text("About")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .imageScale(.small)
                        .font(Font.body.weight(.semibold))
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    var creditsPopup: some View {
        List {
            Section(header: Text("App information")) {
                creditsRow("Application", "FootballScores")
                creditsRow("Version", "1.0")
                creditsRow("Developer", "Michał Wiszenko")
            }
            Section(header: Text("Credits")) {
                creditsRow("Logo", "oNline Web Fonts", "https://www.onlinewebfonts.com")
                creditsRow("Live scores", "API-football", "https://www.api-football.com")
            }
        }
        .listStyle(InsetGroupedListStyle())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            showAbout = false
        }
    }

    func creditsRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
        }
    }

    func creditsRow(_ label: String, _ value: String, _ link: String) -> some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            if let url = URL(string: link) {
                Link(value, destination: url)
            } else {
                Text(value)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static let userPreferences = UserPreferences()

    static var previews: some View {
        SettingsView()
            .colorScheme(.dark)
            .environmentObject(userPreferences)
    }
}
