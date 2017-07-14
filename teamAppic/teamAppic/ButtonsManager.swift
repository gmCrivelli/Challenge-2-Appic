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

/// To uses this class, you have to set the buttons sprites color to #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1) and blendfactor to 1 in sks.
class ButtonsManager {
    //
    /// action to increase the button
    let increaseAction = SKAction.scale(by: 1.1, duration: 0.3)
    
    /// action to gray the button
    let grayAction = SKAction.colorize(with: #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1), colorBlendFactor: 0.7, duration: 0)
    
    /// action to light the button
    let lightAction = SKAction.colorize(with: .white, colorBlendFactor: 1, duration: 0)
    
    /// array that contains all buttons
    private var buttons = [SKSpriteNode]()
    
    /// pointer to the button that is selected
    public private(set) var pointerButton : Int = 0
    
    /// increases the scale of a button
    ///
    /// - Parameter node: button that will have its scale increased
    private func increaseScale(node : SKSpriteNode) {
        node.run(increaseAction)
        node.run(lightAction)
    }
    
    /// increases the scale of a button
    ///
    /// - Parameter node: button that will have its scale decreased
    private func decreaseScale(node : SKSpriteNode) {
        node.run(increaseAction.reversed())
        node.run(grayAction)
    }
    
    /// decreases the scale of last button (in leading of array), and increases the scale of the current button (in trailing of array)
    public func swipeUp() {
        decreaseScale(node: self.buttons[self.pointerButton])
        downPointer()
        increaseScale(node: self.buttons[self.pointerButton])
    }
    
    /// decreases the scale of last button (in trailing of array), and increases the scale of the current button (in leading of array)
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
