//
//  BLEPeripheralViewController.swift
//  Actors
//
//  Created by Dario Lencina on 10/24/15.
//  Copyright © 2015 dario. All rights reserved.
//

import UIKit
import Theater

public class PeripheralViewController : UITableViewController {
    
    @IBOutlet weak var statusCell : UITableViewCell!
    
    @IBOutlet weak var onclick : UITableViewCell!
    
    @IBOutlet weak var advertisingRow: UITableViewCell!
    
    @IBOutlet weak var advertisingButton: UIButton!
    
    lazy var system : ActorSystem = ActorSystem(name:"PeripheralSystem")
    
    lazy var peripheral : ActorRef = self.system.actorOf(PeripheralActor.self, name: "PeripheralActor")
    
    public override func viewWillAppear(animated: Bool) {
        peripheral ! SetViewCtrl(ctrl : self)
    }
    
    public override func viewWillDisappear(animated: Bool) {
        if(self.isBeingDismissed() || self.isMovingFromParentViewController()){
            self.system.stop()
        }
    }
    
    @IBAction func toggleAdvertising(sender: AnyObject) {
        peripheral ! PeripheralActor.ToggleAdvertising(sender : nil)
    }
    
    @IBAction func onClick(sender: UIButton) {
        peripheral ! PeripheralActor.OnClick(sender : nil)
    }
}