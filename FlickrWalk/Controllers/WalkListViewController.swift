//
//  WalkListViewController.swift
//  FlickrWalk
//
//  Created by Jernej Zorec on 21/07/2017.
//  Copyright © 2017 Jernej Zorec. All rights reserved.
//

import UIKit
import CoreLocation

class WalkListViewController: UIViewController {

    @IBOutlet weak var startButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var walkPhotoDataSource: WalkPhotoDataSource!
    
    lazy fileprivate var locationManager = LocationManager.shared
    lazy fileprivate var flickrManager = FlickrManager.shared
    
    fileprivate var distance = Measurement(value: 0, unit: UnitLength.meters)
    fileprivate var locationList: [CLLocation] = []
    
    private var tracking = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        locationManager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startButtonTapped(_ sender: Any) {
        
        if (tracking) {
            stopWalk()
            return;
        }
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .denied:
            presentLocationDeniedAlert()
            break
            
        default:
            startWalk()
            break
        }
        
        let status = CLLocationManager.authorizationStatus()
        if (status == CLAuthorizationStatus.notDetermined) {
            
        } else {
    
        }
        
    }
    
    // MARK: Walk tracking methods
    
    func startWalk() {
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
        
        tracking = true
        startButton.title = "Stop"
    }
    
    func stopWalk() {
        locationManager.stopUpdatingLocation()
        
        tracking = false
        startButton.title = "Start"
    }
    
    // MARK: Helper Methods
    
    func presentLocationDeniedAlert() {
        let alert = UIAlertController(title: "Alert", message: "You need you to enable Location permissions for this app. After all, that's what it does. ", preferredStyle: UIAlertControllerStyle.alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(settingsAction)
        
        self.present(alert, animated: true, completion: nil)
    }

}

extension WalkListViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                
                if delta >= 100 {
                    
                    flickrManager.getPhotoIDsForLocation(location: newLocation, completion: { (photos) in
                        
                        if photos.isEmpty {
                            print("No photos for this location 😞")
                            return
                        }
                        
                        let walkLocation = WalkLocation(longitude: newLocation.coordinate.longitude, latitude: newLocation.coordinate.latitude, photoURL: NSURL.init(string: photos.first as! String))
                        self.walkPhotoDataSource.walkPhotos.insert(walkLocation, at: 0)
                        self.tableView.reloadData()
                        
                    })
                }
            }
            
            locationList.append(newLocation)
            
            print(newLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        //        if (status == CLAuthorizationStatus.denied) {
        //            presentLocationDeniedAlert()
        //
        //        } else if (status == CLAuthorizationStatus.authorizedWhenInUse) {
        //            startWalk()
        //        }
    }
}
