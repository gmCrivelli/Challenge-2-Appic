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
    
    /// action to increase the button
    let increaseAction = SKAction.scale(by: 1.1, duration: 0.3)
    
    /// array that contains all buttons
    private var buttons = [SKSpriteNode]()
    
    public private(set) var pointerButton : Int = 0
    
    /// increases the scale of a button
    ///
    /// - Parameter node: button that will have its scale increased
    private func increaseScale(node : SKSpriteNode) {
        node.run(increaseAction)
    }
    
    /// increases the scale of a button
    ///
    /// - Parameter node: button that will have its scale decreased
    private func decreaseScale(node : SKSpriteNode) {
        node.run(increaseAction.reversed())
    }
    
    /// responsible to make the effect of swipe up in the buttons
    public func swipeUp() {
        decreaseScale(node: self.buttons[self.pointerButton])
        downPointer()
        increaseScale(node: self.buttons[self.pointerButton])
    }
    
    /// responsible to make the effect of swipe down in the buttons
    public func swipeDown() {
        decreaseScale(node: self.buttons[self.pointerButton])
        upPointer()
        increaseScale(node: self.buttons[self.pointerButton])
    }
    
    /// sures that when the pointer is increased, it will not access a invalid position
    private func upPointer() {
        if (self.pointerButton < (self.buttons.count - 1)) {
            self.pointerButton += 1
        }
    }
    /// sures that when the pointer is decreased, it will not access a invalid position
    private func downPointer() {
        if (self.pointerButton > 0) {
            self.pointerButton -= 1
        }
    }
    
    /// inserts all buttons
    ///
    /// - Parameter nodeArray: array with all buttons
    public func insertButton(nodeArray : [SKSpriteNode]) {
        for node in nodeArray {
            self.buttons.append(node)
        }
        increaseScale(node: self.buttons[self.pointerButton])
    }
}
