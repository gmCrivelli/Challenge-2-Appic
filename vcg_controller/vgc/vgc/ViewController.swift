//
//  ViewController.swift
//  vgc
//
//  Created by SERGIO J RAFAEL ORDINE on 6/7/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import UIKit
import VirtualGameController

class ViewController: UIViewController {
    
    var colorFlag: Bool = false
    
    @IBOutlet weak var pointer: UIView!
    
    @IBOutlet var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1 - Publishes the central service
        VgcManager.startAs(.Central, appIdentifier: "vgc", customElements: VGCCustomElements(), customMappings: CustomMappings())
        
        //2 - Set observers for controller connection/disconnection
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.controllerDidConnect(_:)), name: VgcControllerDidConnectNotification, object: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Connection Notification Methods
    @objc func controllerDidConnect(notification: NSNotification) {
        
        guard let newController: VgcController = notification.object as? VgcController else {
            return
        }
        
        //Value Handler for micro gamepad (tv Siri Remote - button A)
        newController.microGamepad?.buttonA.valueChangedHandler = { [unowned self](button, pressure, pressed) in
            self.pointer.backgroundColor = self.colorFlag ? UIColor.blueColor():UIColor.blackColor()
            self.colorFlag = !self.colorFlag
        }
        
        //Value Handler for extended gamepad (iPhone peripheral - button A)
        newController.extendedGamepad?.buttonA.valueChangedHandler = { [unowned self](button, pressure, pressed) in
            self.pointer.backgroundColor = self.colorFlag ? UIColor.greenColor():UIColor.blackColor()
            self.colorFlag = !self.colorFlag
        }
        
        //Value Handler for custom controls
        Elements.customElements.valueChangedHandler = { [unowned self](controller, element) in
            
            //Handle the custom buttom (A integer value)
            if (element.identifier == VGCustomElementType.CustomButton.rawValue) {
                self.pointer.backgroundColor = self.colorFlag ? UIColor.redColor():UIColor.blackColor()
                self.colorFlag = !self.colorFlag
            }
            
            //Handle the text message (A string value)
            if (element.identifier == VGCustomElementType.TextMessage.rawValue) {
                
                let text = element.value as? String
                self.textLabel.text = text

            }
            
        }
        
        
        print ("Conectou!! \(newController)")
        
    }
    
    


}

