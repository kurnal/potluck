//
//  LocationManager.swift
//  PotLuck
//
//  Created by Sierra Seabrease on 4/1/21.
//

import Foundation
import CoreLocation
class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
    }
    
}
extension LocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
}
