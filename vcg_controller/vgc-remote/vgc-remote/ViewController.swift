//
//  ViewController.swift
//  vgc-remote
//
//  Created by SERGIO J RAFAEL ORDINE on 6/7/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit
import VirtualGameController

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!


    override func viewDidLoad() {

        super.viewDidLoad()
       
        
        //1 - Publishes the peripheral device
        VgcManager.startAs(.Peripheral, appIdentifier: "vgc", customElements: VGCCustomElements(), customMappings: CustomMappings())
        
        VgcManager.peripheral.deviceInfo = DeviceInfo(deviceUID: "", vendorName: "", attachedToDevice: false, profileType: .ExtendedGamepad, controllerType: .Software, supportsMotion: true)

        //3 - Service lookup methods
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.foundService(_:)), name: VgcPeripheralFoundService, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.peripheralDidConnect(_:)), name: VgcPeripheralDidConnectNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.peripheralDidDisconnect(_:)), name: VgcPeripheralDidDisconnectNotification, object: nil)
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
       // VgcManager.peripheral.stopBrowsingForServices()
        VgcManager.peripheral.browseForServices()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Service lookup observers
    @objc func foundService(notification: NSNotification) {
        let vgcService = notification.object as? VgcService
        
        let reloadTable = NSBlockOperation { 
            self.tableView.reloadData()
        }
        
        NSOperationQueue.mainQueue().addOperation(reloadTable)
        
        print("Found \(vgcService?.fullName)")
    }
    
    @objc func peripheralDidConnect(notification: NSNotification) {
        // Control was able to connect to central
        // stop browsing other services.
        VgcManager.peripheral.stopBrowsingForServices()
        print("Peripheral did connected to: \(notification.name)")
        
        //Move to controller screen
        performSegueWithIdentifier("ControllerSegue", sender: self)
    }
    
    @objc func peripheralDidDisconnect(notification: NSNotification) {
        print("Peripheral did disconnected to: \(notification.name)")
    }
    
    //MARK: Table View data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VgcManager.peripheral.availableServices.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ServiceCell")
        
        
        cell?.textLabel?.text = VgcManager.peripheral.availableServices[indexPath.row].fullName
        
        return cell!
        
    }
    
    //MARK: Table view delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // try to connect to the central
        VgcManager.peripheral.connectToService(VgcManager.peripheral.availableServices[indexPath.row])
    }
    

}

