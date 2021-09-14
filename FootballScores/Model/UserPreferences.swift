//
//  UserPreferences.swift
//  FootballScores
//
//  Created by Michal on 12/09/2021.
//

import Foundation

final class UserPreferences: ObservableObject {
    @Published var widgetRefreshTime: Date = UserDefaults.standard.object(forKey: "WidgetRefreshTime") as? Date ?? Calendar.current.startOfDay(for: Date()) {
        didSet {
            UserDefaults.standard.set(self.widgetRefreshTime, forKey: "WidgetRefreshTime")
        }
    }
    
    @Published var apiKey: String = UserDefaults.standard.object(forKey: "ApiKey") as? String ?? "" {
        didSet {
            UserDefaults.standard.set(self.apiKey, forKey: "ApiKey")
        }
    }
}
