//
//  ButtonController.swift
//  vgc-remote
//
//  Created by Matheus Rocco Ferreira on 6/7/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import VirtualGameController


class ButtonController: UIViewController {
    
    @IBOutlet var textMessage: UITextField!

    @IBAction func buttonTapped(sender: AnyObject) {
        
        //Send the regular button A information to central
        let buttonA = VgcManager.elements.buttonA
        buttonA.value = 1.0
        VgcManager.peripheral.sendElementState(buttonA)
    }
    
    @IBAction func customTapped(sender: AnyObject) {
        
        //Send a custom button click (Integer value)
            VgcManager.elements.custom[VGCustomElementType.CustomButton.rawValue]!.value = 1
            VgcManager.peripheral.sendElementState(VgcManager.elements.custom[VGCustomElementType.CustomButton.rawValue]!)
        
        
    }

    @IBAction func sendMessage(sender: AnyObject) {
        
        //Send a custom text message to central (String value)
        VgcManager.elements.custom[VGCustomElementType.TextMessage.rawValue]!.value = textMessage.text!
        VgcManager.peripheral.sendElementState(VgcManager.elements.custom[VGCustomElementType.TextMessage.rawValue]!)
        
    }
}
