//
//  Currently.swift
//  Cloudy
//
//  Created by Naveen Kumar Sangi on 28/05/16.
//  Copyright © 2016 Naveen Kumar Sangi. All rights reserved.
//

import Foundation
import UIKit

struct Currently {
    
    var apparentTemperature: String? //
    var temperature: Int?
    var time: String?
    var cloudCover: Double? //
    var dewPoint: Double?
    var humidity: Double?
    var icon: UIImage?
    var ozone: Double? //
    var precipIntensity: Double? //
    var precipProbability: Double?
    var pressure: Double? //
    var visibility: Double? //
    var windBearing: Int? //
    var windSpeed: Double?
    var summary: String?
    
    init(weatherDictionary: [String:AnyObject]) {
        print(weatherDictionary["currently"])
        
            let currentWeather = weatherDictionary["currently"] as! [String: AnyObject]
    
            if let temp = currentWeather["temperature"] as? Double {
                temperature = Int(temp)
            }
            
            humidity = currentWeather["humidity"] as? Double
            
            if let value = currentWeather["precipProbability"] as? Double, value1 = currentWeather["precipIntensity"] as? Double {
                precipProbability = value
                precipIntensity = value1
            }
            
            if let iconString = currentWeather["icon"] as? String {
                icon = weatherIconFromString(iconString)
            }
            
            if let currentTime = currentWeather["time"] as? Int {
                time = dateStringFromUnixTime(currentTime)
            }
            
            apparentTemperature = currentWeather["apparentTemperature"] as? String
            
            if let dp = currentWeather["dewPoint"] as? String {
                dewPoint = Double(dp)
            }
            
            if let wb = currentWeather["windBearing"] as? String {
                windBearing = Int(wb)
            }
    
            windSpeed = currentWeather["windSpeed"] as? Double
            visibility = currentWeather["visibility"] as? Double
            pressure = currentWeather["pressure"] as? Double
            
            if let cc = currentWeather["cloudCover"] as? String {
                cloudCover = Double(cc)
            }
            
            if let oz = currentWeather["ozone"] as? String {
                ozone = Double(oz)
            }
            
            summary = currentWeather["summary"] as? String
    }
    
}

func dateStringFromUnixTime(unixTime: Int) -> String {
    let timeInSeconds = NSTimeInterval(unixTime)
    let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.timeStyle = .MediumStyle
    
    return dateFormatter.stringFromDate(weatherDate)
}

func weatherIconFromString(stringIcon: String?) -> UIImage {

    var imageName: String
    
    if let string = stringIcon {
        switch string {
        case "clear-day":
            imageName = "clear-day"
        case "clear-night":
            imageName = "clear-night"
        case "rain":
            imageName = "rain"
        case "snow":
            imageName = "snow"
        case "sleet":
            imageName = "sleet"
        case "wind":
            imageName = "wind"
        case "fog":
            imageName = "fog"
        case "cloudy":
            imageName = "cloudy"
        case "partly-cloudy-day":
            imageName = "partly-cloudy"
        case "partly-cloudy-night":
            imageName = "cloudy-night"
        default:
            imageName = "default"
        }
    } else {
        imageName = "default"
    }
    
    let iconImage = UIImage(named: imageName)
    return iconImage!
    
}

func Fahrenheit2Celsius(f: Int) -> Int {
    return Int((Double(f)-32.0) / 1.8)
}




