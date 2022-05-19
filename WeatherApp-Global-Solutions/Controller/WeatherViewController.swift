//
//  ViewController.swift
//  WeatherApp-Global-Solutions
//
//  Created by Nodirbek on 18/05/22.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    let locationManager = CLLocationManager()
    var query: String?
    var itemViews: [UIView] = []
    
    private let locationButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "location.circle.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let celciusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 35, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "15 °C"
        label.textAlignment = .right
        return label
    }()
    
    private let countryNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "New York"
        label.textAlignment = .right
        return label
    }()
    
    private let searchController: UISearchController = {
        let search = UISearchController()
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type a city name..."
        return search
    }()
    
    private let weatherImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: "sun.max")
        image.tintColor = .black
        return image
    }()
    
    private let backgroundImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.masksToBounds = true
        image.image = UIImage(named: "image")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupUI()
    }
    
    private func configure(){
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.tintColor = .label
        searchController.searchBar.delegate = self
        locationButton.addTarget(self, action: #selector(didTapLocation), for: .touchUpInside)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func setupUI(){
        itemViews = [backgroundImage, weatherImage, celciusLabel, countryNameLabel, locationButton]
        for itemView in itemViews {
            view.addSubview(itemView)
        }
        
        NSLayoutConstraint.activate([
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            weatherImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            weatherImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 170),
            weatherImage.heightAnchor.constraint(equalToConstant: 130),
            weatherImage.widthAnchor.constraint(equalToConstant: 130),
            
            celciusLabel.topAnchor.constraint(equalTo: weatherImage.bottomAnchor, constant: 20),
            celciusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            celciusLabel.heightAnchor.constraint(equalToConstant: 40),
            celciusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            countryNameLabel.topAnchor.constraint(equalTo: celciusLabel.bottomAnchor, constant: 20),
            countryNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            countryNameLabel.heightAnchor.constraint(equalToConstant: 30),
            countryNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            locationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            locationButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 140),
            locationButton.heightAnchor.constraint(equalToConstant: 40),
            locationButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func getWeather(query: String){
        APICaller.shared.getData(query: query) {[weak self] result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self?.countryNameLabel.text = model.cityName
                    self?.celciusLabel.text = "\(model.temperature)°C"
                    self?.weatherImage.image = UIImage(systemName: model.condition)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getLocation(lat: CLLocationDegrees, lon: CLLocationDegrees){
        APICaller.shared.getLocation(latitude: lat, longitude: lon) { [weak self] result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self?.countryNameLabel.text = model.cityName
                    self?.celciusLabel.text = "\(model.temperature)°C"
                    self?.weatherImage.image = UIImage(systemName: model.condition)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc private func didTapLocation(){
        locationManager.requestLocation()
    }
}

 
extension WeatherViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard (searchBar.text != nil) else { return }
        query = searchBar.text
        guard let query = query else { return }
        getWeather(query: query)
        searchBar.text = ""
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let location = locations.last else { return }
            locationManager.startUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            getLocation(lat: lat, lon: lon)
            locationManager.stopUpdatingLocation()
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
