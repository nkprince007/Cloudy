//
//  Daily.swift
//  Cloudy
//
//  Created by Naveen Kumar Sangi on 28/05/16.
//  Copyright © 2016 Naveen Kumar Sangi. All rights reserved.
//

import Foundation
import UIKit

struct Daily {
    var summary: [String?] = []
    var tempMin: [Int?] = []
    var tempMax: [Int?] = []
    var icon: [UIImage?] = []
    var time: [UInt?] = []
    var day: [String?] = []
    var summaryOverview: String?
    var dateCreated: NSDate?
    
    init(weatherDictionary: [String: AnyObject]) {
        if let daily = weatherDictionary["daily"] as? [String: AnyObject] {
            summaryOverview = daily["summary"] as? String
            if let data = daily["data"] as? [AnyObject] {
                for x in data {
                    if let item = x as? [String: AnyObject] {
                        if let value = item["summary"] as? String {
                            summary.append(value)
                        }
                        if let value = item["icon"] as? String {
                            icon.append(weatherIconFromString(value))
                        }
                        if let value = item["temperatureMin"] as? Double {
                            tempMin.append(Int(value))
                        }
                        if let value = item["temperatureMax"] as? Double {
                            tempMax.append(Int(value))
                        }
                        if let value = item["time"] as? UInt {
                            time.append(value)
                            let (weekDay,date) = weekStringFromUnixTime(value)
                            day.append(weekDay)
                            dateCreated = date
                        }
                    }
                }
            }
        }
    }
}

func weekStringFromUnixTime(unixTime: UInt) -> (String,NSDate) {
    let timeInSeconds = NSTimeInterval(unixTime)
    let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
    
    let dateFormatter = NSDateFormatter()
//    dateFormatter.timeStyle = .MediumStyle
    dateFormatter.dateFormat = "EEE"
    
    return (dateFormatter.stringFromDate(weatherDate),weatherDate)
}
