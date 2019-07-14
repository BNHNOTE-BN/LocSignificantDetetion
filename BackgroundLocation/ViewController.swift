//
//  ViewController.swift
//  BackgroundLocation
//
//  Created by Banyar on 8/7/19.
//  Copyright © 2019 Banyar. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, LocationServiceDelegate {
    
    @IBOutlet weak var LocationTblView: UITableView!
    var updatedLocation : [String] = []
    var userDefault: UserDefaults!
    let locService = LocationService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        print("File Location", FileManager.default.urls(for: .documentationDirectory, in: .userDomainMask).first)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        locService.delegat = self
        locService.locManager.requestAlwaysAuthorization()
    }
    
    
    
    func setup(){
        self.LocationTblView.dataSource = self
        self.LocationTblView.delegate = self
        userDefault = UserDefaults.standard
        
        self.updatedLocation = userDefault.array(forKey: LocationKey) as? [String] ?? []
        self.LocationTblView.reloadData()
        
    }
    
    
    func didLocationUpdated(_ locArr: [String]) {
        self.updatedLocation = locArr
        self.LocationTblView.reloadData()
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.updatedLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = updatedLocation[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        return cell
    }
}

