//
//  LocationViewModel.swift
//  Weather
//
//  Created by Sabri Belguerma on 19/09/2021.
//

import CoreLocation

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
	@Published var authorizationStatus: CLAuthorizationStatus
	@Published var lastSeenLocation: CLLocation?
	@Published var currentPlacemark: CLPlacemark?

	private let locationManager: CLLocationManager

	override init() {
		locationManager = CLLocationManager()
		authorizationStatus = locationManager.authorizationStatus

		super.init()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.distanceFilter = 0.4
		locationManager.startUpdatingLocation()
	}



	func requestPermission() {
		locationManager.requestWhenInUseAuthorization()
	}

	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		authorizationStatus = manager.authorizationStatus
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		lastSeenLocation = locations.first
		fetchCountryAndCity(for: locations.first)
	}

	func fetchCountryAndCity(for location: CLLocation?) {
		guard let location = location else { return }
		let geocoder = CLGeocoder()
		geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
			self.currentPlacemark = placemarks?.first
		}
	}
}
