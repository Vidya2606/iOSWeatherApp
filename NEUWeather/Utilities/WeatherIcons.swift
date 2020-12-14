//
//  WeatherIcons.swift
//  NEUWeather
//
//  Created by Maheshwara Reddy on 12/3/20.
//

import Foundation
import UIKit

func isDay() -> Bool {
    let hour = Calendar.current.component(.hour, from: Date())
    if hour >= 6 && hour <= 18 {
        return true
    }
    return false
}

let dayIcons : [ String: UIImage] = [
    "Sunny": UIImage(named: "01-s")!,
    "Mostly Sunny": UIImage(named: "02-s")!,
    "Partly Sunny": UIImage(named: "03-s")!,
    "Intermittent Clouds": UIImage(named: "04-s")!,
    "Hazy sunshine": UIImage(named: "05-s")!,
    "Mostly Cloudy": UIImage(named: "06-s")!,
    "Cloudy": UIImage(named: "07-s")!,
    "Dreary (Overcast)": UIImage(named: "08-s")!,
    "Fog": UIImage(named: "11-s")!,
    "Showers": UIImage(named: "12-s")!,
    "Mostly Cloudy w/ Showers": UIImage(named: "13-s")!,
    "Partly Sunny w/ Showers": UIImage(named: "14-s")!,
    "T-Storms": UIImage(named: "15-s")!,
    "Mostly Cloudy w/ T-Storms": UIImage(named: "16-s")!,
    "Partly Sunny w/ T-Storms": UIImage(named: "17-s")!,
    "Rain": UIImage(named: "18-s")!,
    "Flurries": UIImage(named: "19-s")!,
    "Mostly Cloudy w/ Flurries": UIImage(named: "20-s")!,
    "Partly Sunny w/ Flurries": UIImage(named: "21-s")!,
    "Snow": UIImage(named: "22-s")!,
    "Mostly Cloudy w/ Snow": UIImage(named: "23-s")!,
    "Ice": UIImage(named: "24-s")!,
    "Sleet": UIImage(named: "25-s")!,
    "Freezing Rain": UIImage(named: "26-s")!,
    "Rain and Snow": UIImage(named: "29-s")!,
    "Hot": UIImage(named: "30-s")!,
    "Cold": UIImage(named: "31-s")!,
    "Windy": UIImage(named: "32-s")!,
]


let nightIcons: [String: UIImage] = [
    "Cloudy": UIImage(named: "07-s")!,
    "Dreary (Overcast)": UIImage(named: "08-s")!,
    "Fog": UIImage(named: "11-s")!,
    "Showers": UIImage(named: "12-s")!,
    "T-Storms": UIImage(named: "15-s")!,
    "Rain": UIImage(named: "18-s")!,
    "Flurries": UIImage(named: "19-s")!,
    "Snow": UIImage(named: "22-s")!,
    "Ice": UIImage(named: "24-s")!,
    "Sleet": UIImage(named: "25-s")!,
    "Freezing Rain": UIImage(named: "26-s")!,
    "Rain and Snow": UIImage(named: "29-s")!,
    "Hot": UIImage(named: "30-s")!,
    "Cold": UIImage(named: "31-s")!,
    "Windy": UIImage(named: "32-s")!,
    "Clear": UIImage(named: "33-s")!,
    "Mostly Clear": UIImage(named: "34-s")!,
    "Partly Cloudy": UIImage(named: "35-s")!,
    "Intermittent Clouds": UIImage(named: "36-s")!,
    "Hazy Moonlight": UIImage(named: "37-s")!,
    "Mostly Cloudy": UIImage(named: "38-s")!,
    "Partly Cloudy w/ Showers": UIImage(named: "39-s")!,
    "Mostly Cloudy w/ Showers": UIImage(named: "40-s")!,
    "Partly Cloudy w/ T-Storms": UIImage(named: "41-s")!,
    "Mostly Cloudy w/ T-Storms": UIImage(named: "42-s")!,
    "Mostly Cloudy w/ Flurries": UIImage(named: "43-s")!,
    "Mostly Cloudy w/ Flurries": UIImage(named: "44-s")!
]
