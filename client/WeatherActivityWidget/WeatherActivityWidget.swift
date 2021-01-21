//
//  WeatherActivityWidget.swift
//  WeatherActivityWidget
//
//  Created by Infinum on 16.01.2021..
//

import WidgetKit
import SwiftUI
 
struct ActivityWidgetEntry: TimelineEntry {
 
    enum State {
        case normal([Activity])
        case notLogged
        case noActivities
        case error
    }
 
    var date: Date
    let state: State
 
    static var activityWidgetPlaceholder: Self {
        let activities = [
            Activity(
                id: 1,
                startTime: "2021-01-01T20:00:00.000Z",
                title: "Football with crew",
                locationName: "TTS Varaždin",
                name: "Sports"),
            Activity(
                id: 2,
                startTime: "2021-05-01T22:00:00.000Z",
                title: "Business meeting",
                locationName: "FOI",
                name: "Business"),
            Activity(
                id: 3,
                startTime: "2021-10-01T23:00:00.000Z",
                title: "Fun night with my lady",
                locationName: "Home",
                name: "Romance")
        ]
        let entry = Self(date: Date(), state: .normal(activities))
        return entry
    }
}
 
struct ActivityWidgetProvider: TimelineProvider {
    let service = ActivityService()
 
    typealias Entry = ActivityWidgetEntry
 
    func placeholder(in context: Context) -> ActivityWidgetEntry {
        return .activityWidgetPlaceholder
    }
 
    func getSnapshot(in context: Context, completion: @escaping (ActivityWidgetEntry) -> Void) {
        return completion(placeholder(in: context))
    }
 
    func getTimeline(in context: Context, completion: @escaping (Timeline<ActivityWidgetEntry>) -> ()) {
        if let sessionToken = SessionManager.shared.getToken() {
            service.getWidgetActivities(
                success: { (activities) in
                    if activities.isEmpty {
                        completion(.singleEntryActivityWidgetTimeline(forWidgetState: .noActivities))
                    } else {
                        completion(.singleEntryActivityWidgetTimeline(forWidgetState: .normal(activities)))
                    }
                },
                failure: { error in
                    completion(.singleEntryActivityWidgetTimeline(forWidgetState: .error))
                }
            )
        } else {
            completion(.singleEntryActivityWidgetTimeline(forWidgetState: .notLogged))
        }
        
    }
}
 
extension Timeline where EntryType == ActivityWidgetEntry {
    static func currentAndRefreshDate() -> (current: Date, refresh: Date) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        return (currentDate, refreshDate)
    }
 
    static func singleEntryActivityWidgetTimeline(forWidgetState state: ActivityWidgetEntry.State) -> Timeline<ActivityWidgetEntry> {
        let dates = Self.currentAndRefreshDate()
        let entry = ActivityWidgetEntry(date: dates.current, state: state)
        let timeline = Timeline(entries: [entry], policy: .after(dates.refresh))
        return timeline
    }
}
 
@main
struct WeatherActivityWidget: Widget {
    let kind: String = "WeatherActivityWidget"
 
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ActivityWidgetProvider()) { entry in
            WeatherActivityWidgetView(entry: entry)
        }
        .configurationDisplayName("Upcoming activities")
        .description("Shows upcoming activities")
        .supportedFamilies([.systemSmall, .systemLarge])
    }
}
