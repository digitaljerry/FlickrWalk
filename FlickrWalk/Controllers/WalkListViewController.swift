//
//  WalkListViewController.swift
//  FlickrWalk
//
//  Created by Jernej Zorec on 21/07/2017.
//  Copyright © 2017 Jernej Zorec. All rights reserved.
//

import UIKit

class WalkListViewController: UIViewController {

    @IBOutlet weak var startButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

