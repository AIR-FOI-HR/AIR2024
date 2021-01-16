//
//  WeatherActivityWidgetView.swift
//  WeatherActivity
//
//  Created by Infinum on 16.01.2021..
//

import SwiftUI
import WidgetKit
 
struct ActivityRow: View {
    let activity: Activity
 
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(activity.title)
                .bold()
                .font(.title3)
                .lineLimit(1)
            Text(activity.locationName)
            Text(activity.name)
                .font(.subheadline)
                .italic()
        }
    }
}
 
struct SingleActivityView: View {
    let activity: Activity
 
    var body: some View {
        VStack(alignment: .leading) {
            Text(activity.name)
                .font(.title2)
                .fontWeight(.bold)
            Text(activity.locationName)
        }
        .widgetURL(activity.deepLinkUrl)
    }
}
 
struct ActivityList: View {
    static let listSize = 3
    let activities: [Activity]
 
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 12) {
            ForEach(activities.prefix(Self.listSize)) { activity in
                Link(destination: activity.deepLinkUrl) {
                    ActivityRow(activity: activity)
                    Divider()
                }
            }
        }
    }
}
 
struct ActivityErrorView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 16, content: {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .foregroundColor(.orange)
                .frame(width: 40, height: 40)
            Text("Fetching hot repos data failed.\nPlease try to refresh later.")
                .font(.callout)
                .multilineTextAlignment(.center)
        })
        .padding()
    }
}
 
struct WidgetTitleView: View {
 
    enum Style {
        case singleActivity
        case activities
    }
 
    var style: Style
 
    var body: some View {
        switch style {
        case .activities:
            HStack(spacing: 16) {
                Text("activities")
                    .bold()
                    .font(.title)
            }
        case .singleActivity:
            Text("activity")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
        }
    }
}
 
struct WeatherActivityWidgetView: View {
    var entry: ActivityWidgetProvider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    static func contentView(
        for state: ActivityWidgetEntry.State,
        family: WidgetFamily
    ) -> some View
    {
        switch state {
        case .error:
            return AnyView(ActivityErrorView())
        case .normal(let repos):
            if family == .systemSmall {
                return AnyView(SingleActivityView(activity: repos.first!))
            } else {
                return AnyView(ActivityList(activities: repos))
            }
        }
    }
 
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            WidgetTitleView(style: family == .systemSmall ? .singleActivity : .activities)
            Self.contentView(for: entry.state, family: family)
        }
        .padding()
    }
}
 
struct WeatherActivityWidget_Preview: PreviewProvider {
    static var previews: some View {
        WeatherActivityWidgetView(entry: .activityWidgetPlaceholder)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
