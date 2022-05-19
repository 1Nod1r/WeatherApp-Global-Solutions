//
//  WeatherModel.swift
//  WeatherApp-Global-Solutions
//
//  Created by Nodirbek on 19/05/22.
//

import Foundation

struct WeatherModel {
    let picutreId: Int
    let cityName: String
    let temperature: String
    
    var condition: String {
        switch picutreId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
}
