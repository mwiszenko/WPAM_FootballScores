//
//  UserPreferences.swift
//  FootballScores
//
//  Created by Michal on 12/09/2021.
//

import Foundation

final class UserPreferences: ObservableObject {
    static let suiteName = "group.com.mwiszenko.FootballScores"
    
    @Published var widgetRefreshTime: Date =
        UserDefaults(suiteName: "group.com.mwiszenko.FootballScores")!.object(forKey: "WidgetRefreshTime") as? Date ?? Calendar.current.startOfDay(for: Date()) {
        didSet {
            UserDefaults(suiteName: "group.com.mwiszenko.FootballScores")!.set(self.widgetRefreshTime, forKey: "WidgetRefreshTime")
        }
    }
    
    @Published public var apiKey: String = UserDefaults(suiteName: "group.com.mwiszenko.FootballScores")!.object(forKey: "ApiKey") as? String ?? "" {
        didSet {
            UserDefaults(suiteName: "group.com.mwiszenko.FootballScores")!.set(self.apiKey, forKey: "ApiKey")
        }
    }
}
