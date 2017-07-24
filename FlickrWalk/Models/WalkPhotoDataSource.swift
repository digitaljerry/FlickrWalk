//
//  WalkDataSource.swift
//  FlickrWalk
//
//  Created by Jernej Zorec on 21/07/2017.
//  Copyright © 2017 Jernej Zorec. All rights reserved.
//

import UIKit

class WalkPhotoDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var walking = false
    var walkPhotos : [WalkLocation] = [WalkLocation]()
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if walkPhotos.count == 0 && !walking {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WalkNotStartedTableViewCell")!
            return cell
        } else if walkPhotos.count == 0 && walking {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WalkEmptyTableViewCell")!
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalkPhotoTableViewCell") as! WalkPhotoTableViewCell
        
        let walkPhoto = walkPhotos[indexPath.row]
        
        if let imageUrl = walkPhoto.photoURL {
            cell.walkPhotoImageView.downloadedFrom(url: imageUrl as URL)
        }
        
        return cell
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(walkPhotos.count, 1)
    }
    
}
