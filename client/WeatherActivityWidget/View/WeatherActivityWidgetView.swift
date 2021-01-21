//
//  WeatherActivityWidgetView.swift
//  WeatherActivity
//
//  Created by Infinum on 16.01.2021..
//

import SwiftUI
import WidgetKit

func getDate(timestamp: String) -> String {
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "dd.MM."
    
    guard let date = dateFormatterGet.date(from: timestamp) else { return "Err" }
    return dateFormatterPrint.string(from: date)
}

func getTime(timestamp: String) -> String {
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "HH:mm"
    
    guard let time = dateFormatterGet.date(from: timestamp) else { return "Err" }
    return dateFormatterPrint.string(from: time)
}

struct ActivityRow: View {
    let activity: Activity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(activity.title)
                .bold()
                .font(.system(size: 20))
                .lineLimit(1)
            HStack(spacing: 10) {
                HStack(spacing: 5) {
                    Text(getDate(timestamp: activity.startTime))
                    Text(getTime(timestamp: activity.startTime))
                }
                Text("@ " + activity.locationName)
                    .italic()
                    .lineLimit(1)
            }
            .font(.system(size: 16))
            HStack (spacing: 5) {
                Image(activity.name.lowercased())
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
                Text(activity.name)
                    .font(.system(size: 16))
                    .italic()
            }
        }
    }
}

struct SingleActivityView: View {
    let activity: Activity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Next activity")
                .font(.headline)
                .fontWeight(.bold)
                .lineLimit(2)
                .foregroundColor(.widgetTitle)
            VStack(alignment: .leading, spacing: 5){
                Text(activity.title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                HStack(spacing: 3) {
                    Text(getDate(timestamp: activity.startTime))
                    Text(getTime(timestamp: activity.startTime))
                }
                .font(.system(size: 14))
                Text("@ " + activity.locationName)
                    .font(.system(size: 14))
                    .italic()
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .widgetURL(activity.deepLinkUrl)
    }
}

struct ActivityList: View {
    static let listSize = 3
    let activities: [Activity]
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Text("Upcoming activities")
                .bold()
                .font(.title2)
                .foregroundColor(.widgetTitle)
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(activities.prefix(Self.listSize)) { activity in
                    Link(destination: activity.deepLinkUrl) {
                        ActivityRow(activity: activity)
                        Divider()
                    }
                }
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
    }
}

struct ActivityErrorView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 16, content: {
            Image(systemName: "x.circle.fill")
                .resizable()
                .foregroundColor(.red)
                .frame(width: 40, height: 40)
            Text("Error")
                .font(.system(size: 14))
                .bold()
                .multilineTextAlignment(.center)
            Text("Err.. fetching activities failed.\nGrab a coffe and try to refresh later.")
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
        })
        .padding()
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
    }
}

struct NoActivitiesView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 16, content: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .foregroundColor(.widgetBlue)
                .frame(width: 40, height: 40)
            Text("No activities")
                .font(.system(size: 14))
                .bold()
                .multilineTextAlignment(.center)
            Text("Hmmm.. Looks like you don't have any upcoming activities.\nGo add some!")
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
        })
        .padding()
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .widgetURL(URL(string: "\(Constants.widgetURLScheme)://add")!)
    }
}

struct NotLoggedView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 16, content: {
            Image(systemName: "person.fill.xmark")
                .resizable()
                .foregroundColor(.yellow)
                .frame(width: 40, height: 30)
            Text("Not logged in")
                .font(.system(size: 14))
                .bold()
                .multilineTextAlignment(.center)
            Text("Looks like you are not logged in.\nGet yourself logged!")
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
        })
        .padding()
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .widgetURL(URL(string: "\(Constants.widgetURLScheme)://log")!)
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
        case .noActivities:
            return AnyView(NoActivitiesView())
        case .notLogged:
            return AnyView(NotLoggedView())
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Self.contentView(for: entry.state, family: family)
        }
        .padding()
        .background(Color.widgetBody)
    }
}

struct WeatherActivityWidget_Preview: PreviewProvider {
    static var previews: some View {
        WeatherActivityWidgetView(entry: .activityWidgetPlaceholder)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
