//
//  TimeDetailsManager.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 07.12.2020..
//

import Foundation

class TimeDetailsManager {
    
    let dateFormatter = DateFormatter()
    
    // Maximum of 5 days apart -> Reason: OpenWeatherMap API Free version gives only forecast for 5 days infront
    func isDateRangeValid(date: Date) -> Bool {
        
        let nowDate = Date()
        let calendar = Calendar.current
        let nextDate = calendar.date(byAdding: .day, value: Constants.validDateRange, to: nowDate)
        
        let range = nowDate...nextDate!
        if range.contains(date) {
            return true
        }
        return false
    }
    
    func combineDateAndTime(date: Date, time: Date) -> Date {
        
        let calendar = Calendar.current
        
        let timeComponents: DateComponents? = calendar.dateComponents([.hour, .minute, .second], from: time)
        var dateComponents: DateComponents? = calendar.dateComponents([.day, .month, .year], from: date)
        
        dateComponents?.hour = timeComponents?.hour
        dateComponents?.minute = timeComponents?.minute
        dateComponents?.second = timeComponents?.second
        
        if let newDate: Date = calendar.date(from: dateComponents!) {
            return newDate
        }
        return date
    }
    
    func getTime(fromDate date: Date, timeFormat format: TimeFormat) -> String {
        
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: date)
    }
    
    func getDate(fromDate date: Date) -> String {
        
        dateFormatter.dateFormat = DateFormat.databaseFormat.rawValue;
        return dateFormatter.string(from: date)
    }
    
    func addTime(to toDate: Date, hours hoursValue: Int = Constants.defaultTimeInterval) -> Date {
        
        guard let modifiedDate = Calendar.current.date(byAdding: .hour, value: hoursValue, to: toDate) else { return toDate }
        return modifiedDate
    }
    
    func getDateFromString(timestamp: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let date = dateFormatter.date(from: timestamp) else { return Date() }
        return date
    }
    
    func getCorrectDateAsString(from: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard
            var newDate = dateFormatter.date(from: from)
        else { return nil}
        newDate = addTime(to: newDate, hours: -1)
        
        let timestamp = dateFormatter.date(from: dateFormatter.string(from: newDate))
        return timestamp
    }
}
