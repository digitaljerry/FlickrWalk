//
//  FlickrManager.swift
//  FlickrWalk
//
//  Created by Jernej Zorec on 21/07/2017.
//  Copyright © 2017 Jernej Zorec. All rights reserved.
//

import CoreLocation

class FlickrManager {
    static let shared = FlickrManager()
    
    public func getPhotoIDsForLocation(location: CLLocation?, completion: @escaping (_ result: Array<Any>) -> Void) {
        
        let latitude = location?.coordinate.latitude ?? 46.5617351
        let longitude = location?.coordinate.longitude ?? 15.6471383
        
        let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=6e530698222e9fdc4189dd8e2430ea2e&lat=\(latitude)&lon=\(longitude)&format=json&nojsoncallback=1")!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("request failed \(String(describing: error))")
                return
            }
            
            do {
                
                var allPhotos = [String]()
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let photos = json["photos"] as? [String: Any] {
                        
                        let p = photos["photo"] as? [Any]
                        let first = p?.first as? [String: Any]
                        
                        guard (first != nil) else {
                            print("No photos for this location")
                            DispatchQueue.main.async {
                                completion([])
                            }
                            return
                        }
                        
                        // https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
                        // farm-id: 1
                        // server-id: 2
                        // photo-id: 1418878
                        // secret: 1e92283336
                        // size: m
                        
                        let farmID = first?["farm"] as! Int
                        let serverID = first?["server"] as! String
                        let id = first?["id"] as! String
                        let secret = first?["secret"] as! String
                        
                        let url = "https://farm\(farmID).staticflickr.com/\(serverID)/\(id)_\(secret).jpg"
                        
                        allPhotos.append(url)
                    }
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
                
                //print(allPhotos)
                
                DispatchQueue.main.async {
                    completion(allPhotos)
                }
            }
            
        }
        task.resume()
    }
    
}
