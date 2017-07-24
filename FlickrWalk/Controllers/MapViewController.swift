//
//  MapViewController.swift
//  FlickrWalk
//
//  Created by Jernej Zorec on 24/07/2017.
//  Copyright © 2017 Jernej Zorec. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    static let DefaultButtonColor = UIButton(type: UIButtonType.system).titleColor(for: .normal)
    
    @IBOutlet weak var mapView: MKMapView!

    dynamic var locationList: [CLLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addObserver(self, forKeyPath: #keyPath(MapViewController.locationList), options: [], context: nil)
        
        loadMap()
    }

    deinit {
        self.removeObserver(self, forKeyPath: #keyPath(MapViewController.locationList))
    }

    // MARK: Map methods
    
    private func loadMap() {
        guard
            locationList.count > 0,
            let region = mapRegion()
            else {
                let alert = UIAlertController(title: "Error",
                                              message: "No locations yet",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(alert, animated: true)
                return
        }
        
        mapView.setRegion(region, animated: true)
        mapView.add(polyLine())
    }
    
    private func mapRegion() -> MKCoordinateRegion? {
        guard
            locationList.count > 0
            else {
                return nil
        }
        
        let latitudes = locationList.map { location -> Double in
            return location.coordinate.latitude
        }
        
        let longitudes = locationList.map { location -> Double in
            return location.coordinate.longitude
        }
        
        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                    longitudeDelta: (maxLong - minLong) * 1.3)
        return MKCoordinateRegion(center: center, span: span)
    }
    
    private func polyLine() -> MKPolyline {
        guard locationList.count > 0 else {
            return MKPolyline()
        }
        
        let coords: [CLLocationCoordinate2D] = locationList.map { location in
            return CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
        return MKPolyline(coordinates: coords, count: coords.count)
    }
    
    // MARK: KVO for location changes
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // We are only interested in changes to our locationList array
        guard keyPath == "locationList" else { return }
        
        // this is just for debugging so lets load all the location points
        // otherwise it would make sense to just append on the map
        loadMap()
    }
    
    // MARK: Actions

    @IBAction func closeButtonTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = MapViewController.DefaultButtonColor
        renderer.lineWidth = 5
        return renderer
    }
}
