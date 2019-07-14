//
//  LocationManagerService.swift
//  BackgroundLocation
//
//  Created by Banyar on 14/7/19.
//  Copyright © 2019 BNH. All rights reserved.
//

import Foundation
import CoreLocation

let LocationKey = "LocationKey"

extension Date{
    func format()->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY:MM:DD HH:mm:ss"
        
        return formatter.string(from: self)
    }
}

protocol LocationServiceDelegate {
    func didLocationUpdated(_ locArr : [String])
}

class LocationService: NSObject, CLLocationManagerDelegate  {
    let locManager : CLLocationManager = CLLocationManager()
    var updatedLocation : [String] = []
    var userDefault : UserDefaults!
    var delegat : LocationServiceDelegate?
    
    override init() {
        super.init()
        userDefault = UserDefaults.standard
        self.updatedLocation = userDefault.array(forKey: LocationKey) as? [String] ?? []
        
        locManager.delegate = self
    }
    
    func checkLocatoinPermission() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            self.locManager.startMonitoringSignificantLocationChanges()
            self.locManager.pausesLocationUpdatesAutomatically = false
        case .authorizedWhenInUse:
            print("I got when in Use")
            self.locManager.startMonitoringSignificantLocationChanges()
            self.locManager.pausesLocationUpdatesAutomatically = false
        case .notDetermined:
            print("I not determin")
        case .restricted:
            print("I got restricted")
        case .denied:
            print("I got denied")
        @unknown default:
            print("Get error")
        }
    }
    
    func saveLocation(){
        userDefault.set(self.updatedLocation, forKey: LocationKey)
        userDefault.synchronize()
        self.delegat?.didLocationUpdated(self.updatedLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocatoinPermission()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLoc = "\(String(describing: locations.first!.coordinate.latitude)) \(locations.first!.coordinate.longitude)- \(Date().format())"
        self.updatedLocation.append(currentLoc)
        print("Did get Update loation")
        self.saveLocation()
    }
}
