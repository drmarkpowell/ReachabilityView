//
//  ViewController.swift
//  ReachabilityView
//
//  Created by drmarkpowell on 01/10/2019.
//  Copyright (c) 2019 drmarkpowell. All rights reserved.
//

import UIKit
import Reachability
import ReachabilityView

class ViewController: UIViewController {

    @IBOutlet weak var reachabilityView: ReachabilityView!
    let reachability = Reachability(hostname: "www.apple.com")! //TODO get from info.plist

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        reachability.whenReachable = { reachability in
            self.reachabilityView.statusOn = true
        }
        reachability.whenUnreachable = { reachability in
            self.reachabilityView.statusOn = false
        }
        do {
            try reachability.startNotifier()
        } catch let err {
            debugPrint("Reachability error: \(err.localizedDescription)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

