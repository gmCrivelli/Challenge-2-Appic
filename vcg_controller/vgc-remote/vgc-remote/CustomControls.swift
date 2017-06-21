//
//  CustomControls.swift
//  vgc-remote
//
//  Created by SERGIO J RAFAEL ORDINE on 6/7/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//


import VirtualGameController

public enum VGCustomElementType: Int {
    
    case CustomButton   = 50
    case TextMessage = 51
}

///
/// Your customElements class must descend from CustomElementsSuperclass
///
public class VGCCustomElements: CustomElementsSuperclass {
    
    public override init() {
        
        super.init()
        
        customProfileElements = [
            CustomElement(name: "CustomButton", dataType: .Int, type:VGCustomElementType.CustomButton.rawValue),
            CustomElement(name: "Message", dataType: .String, type:VGCustomElementType.TextMessage.rawValue)
            
        ]
    }
    
}

