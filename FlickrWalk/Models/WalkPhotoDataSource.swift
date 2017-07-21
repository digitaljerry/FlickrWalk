//
//  WalkDataSource.swift
//  FlickrWalk
//
//  Created by Jernej Zorec on 21/07/2017.
//  Copyright © 2017 Jernej Zorec. All rights reserved.
//

import UIKit

class WalkPhotoDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var walkPhotos : [WalkLocation] = [WalkLocation]()
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalkPhotoTableViewCell") as! WalkPhotoTableViewCell
        
        let walkPhoto = walkPhotos[indexPath.row]
        
        if let imageUrl = walkPhoto.photoURL {
            cell.walkPhotoImageView.downloadedFrom(url: imageUrl as URL)
        }
        
        return cell
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walkPhotos.count
    }
    
}
