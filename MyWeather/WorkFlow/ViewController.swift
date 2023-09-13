//
//  ViewController.swift
//  MyWeather
//
//  Created by Jarae on 11/9/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    private lazy var backgroundImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var locationLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 24, weight: .medium)
        view.numberOfLines = 1
        view.textAlignment = .center
        view.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var temprature: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 78, weight: .regular)
        view.numberOfLines = 1
        view.textAlignment = .center
        view.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .regular)
        view.numberOfLines = 1
        view.textAlignment = .center
        view.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var maxMinTemprature: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .regular)
        view.numberOfLines = 1
        view.textAlignment = .center
        view.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    let todayDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation() 
    }
 
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func setupConstraints() {
        view.addSubiews(backgroundImage)
        backgroundImage.addSubiews(locationLabel, temprature, descriptionLabel, maxMinTemprature)

        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            temprature.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 5),
            temprature.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            temprature.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: temprature.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            maxMinTemprature.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            maxMinTemprature.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            maxMinTemprature.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func fetchData(_ long: Double, _ lat: Double) {
        NetworkService.shared.requestByLocation(longtitude: long, latitude: lat) { result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    let time = self.todayDate.hourValue
                    print(time)
                    if time >= 6 && time <= 18 {
                        self.backgroundImage.image = UIImage(named: "day")
                    } else {
                        self.backgroundImage.image = UIImage(named: "night")
                    }
                    self.locationLabel.text = model.name
                    self.temprature.text = "\(model.main.temp)"
                    self.descriptionLabel.text = model.weather[0].description
                    self.maxMinTemprature.text = "Макс.:\(model.main.tempMax), мин.:\(model.main.tempMin)"
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherLocation()
        }
    }
    
    func requestWeatherLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        fetchData(long, lat)
    }
}

