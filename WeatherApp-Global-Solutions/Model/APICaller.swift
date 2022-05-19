//
//  APICaller.swift
//  WeatherApp-Global-Solutions
//
//  Created by Nodirbek on 18/05/22.
//

import Foundation
import CoreLocation

enum APIErrors: Error {
    case wrongUrl
    case noData
}

struct Constants {
    static let countryUrl = "https://api.openweathermap.org/data/2.5/weather?q=%@&appid=8cdd2969710dde071986030a149ef672&units=metric"
    static let locationUrl = "https://api.openweathermap.org/data/2.5/weather?appid=8cdd2969710dde071986030a149ef672&units=metric"    
}

final class APICaller {
    
    static let shared = APICaller()
    
    private init(){}
    
    typealias WeatherCompletion = ((Result<WeatherModel, Error>) -> Void)
    
    func getData(query: String, completion: @escaping WeatherCompletion ) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        let urlString = String(format: Constants.countryUrl, query)
        
        guard let url = URL(string: urlString) else {
            completion(.failure(APIErrors.wrongUrl))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIErrors.noData))
                return
            }
            do {
                let result = try JSONDecoder().decode(WelcomeData.self, from: data)
                let model = WeatherModel(picutreId: result.weather[0].id, cityName: result.name, temperature: "\(result.main.temp)")
                completion(.success(model))
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping WeatherCompletion){
        let urlString = "\(Constants.locationUrl)&lat=\(latitude)&lon=\(longitude)"
        guard let url = URL(string: urlString)  else {
            completion(.failure(APIErrors.wrongUrl))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(WelcomeData.self, from: data)
                let model = WeatherModel(picutreId: result.weather[0].id, cityName: result.name, temperature: "\(result.main.temp)")
                completion(.success(model))
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    
    }
    
}
