//
//  ButtonsManager.swift
//  teamAppic
//
//  Created by Rodrigo Maximo on 12/07/17.
//  Copyright © 2017 Rodrigo Maximo. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameController
import QuartzCore

class ButtonsManager {
    
    let increaseAction = SKAction.scale(by: 1.2, duration: 0.3)
    
    private var buttons = [SKSpriteNode]()
    
    public private(set) var pointerButton : Int = 0
    
    private func increaseScale(node : SKSpriteNode) {
        node.run(increaseAction)
    }
    
    private func decreaseScale(node : SKSpriteNode) {
        node.run(increaseAction.reversed())
    }
    
    public func swipeUp() {
        decreaseScale(node: self.buttons[self.pointerButton])
        downPointer()
        increaseScale(node: self.buttons[self.pointerButton])
    }
    
    public func swipeDown() {
        decreaseScale(node: self.buttons[self.pointerButton])
        upPointer()
        increaseScale(node: self.buttons[self.pointerButton])
    }
    
    private func upPointer() {
        if (self.pointerButton < (self.buttons.count - 1)) {
            self.pointerButton += 1
        }
    }
    private func downPointer() {
        if (self.pointerButton > 0) {
            self.pointerButton -= 1
        }
    }
    
    public func insertButton(nodeArray : [SKSpriteNode]) {
        for node in nodeArray {
            self.buttons.append(node)
        }
        increaseScale(node: self.buttons[self.pointerButton])
    }
}
