//
//  Model.swift
//  WeatherApp-Global-Solutions
//
//  Created by Nodirbek on 18/05/22.
//

import Foundation


struct WelcomeData: Codable {
    let weather: [Weather]
    let main: Main
    let name: String
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
}

struct Main: Codable {
    let temp: Double
}
