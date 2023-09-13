//
//  NetworkService.swift
//  MyWeather
//
//  Created by Jarae on 13/9/23.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    let apiKey: String = "e9ed1d617e7d7c229660a805cd441635"
    
    func requestByLocation(longtitude: Double, latitude: Double, completion: @escaping(Result<Welcome, Error>) -> Void) {
        guard let url = URL(
            string:"https://api.openweathermap.org/data/2.5/weather?lat=\(latitude.description)&lon=\(longtitude.description)&units=metric&lang=ru&appid=\(apiKey)")
        else {
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {return}
            
            do {
                let value = try JSONDecoder().decode(Welcome.self, from: data)
                completion(.success(value))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
