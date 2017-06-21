//
//  VgcPeripheralNetService.swift
//
//
//  Created by Rob Reuss on 10/1/15.
//
//

import Foundation

#if os(iOS)
    import UIKit
#endif

#if os(iOS) || os(OSX) || os(tvOS)
    import GameController // Needed only because of a reference to playerIndex
#endif

// Set deviceName in a platform specific way
#if os(iOS) || os(tvOS)
let deviceName = UIDevice.currentDevice().name
    public let peripheralBackgroundColor = UIColor(red: 0.76, green: 0.76, blue: 0.76, alpha: 1)
#endif

#if os(OSX)
let deviceName = NSHost.currentHost().localizedName!
    public let peripheralBackgroundColor = NSColor(red: 0.76, green: 0.76, blue: 0.76, alpha: 1)
#endif

// MARK: NetService Peripheral Management

class VgcBrowser: NSObject, NSNetServiceDelegate, NSNetServiceBrowserDelegate, NSStreamDelegate, VgcStreamerDelegate {

    var elements: Elements!
    var peripheral: Peripheral!
    var connectedVgcService: VgcService!
    var localService: NSNetService!
    var inputStream: [StreamDataType: NSInputStream] = [:]
    var outputStream: [StreamDataType: NSOutputStream] = [:]
    var registeredName: String!
    var streamOpenCount: Int!
    var bridgeBrowser: NSNetServiceBrowser!
    var centralBrowser: NSNetServiceBrowser!
    var browsing = false
    var streamer: [StreamDataType: VgcStreamer] = [:]
    var serviceLookup = Dictionary<NSNetService, VgcService>()
    
    init(peripheral: Peripheral) {
        
        super.init()
        
        self.peripheral = peripheral
        
        elements = VgcManager.elements
        
        self.streamer[.LargeData] = VgcStreamer(delegate: self, delegateName: "Browser")
        self.streamer[.SmallData] = VgcStreamer(delegate: self, delegateName: "Browser")
        
        print("Setting up NSNetService for browsing")
        
        self.localService = NSNetService.init(domain: "local.", type: VgcManager.bonjourTypeCentral, name: deviceName, port: 0)
        self.localService.delegate = self
        self.localService.includesPeerToPeer = VgcManager.includesPeerToPeer
        
    }
    
    func closeStreams() {
        
        print("Closing streams")
        if inputStream[.SmallData] != nil { inputStream[.SmallData]!.close() }
        if inputStream[.LargeData] != nil { inputStream[.LargeData]!.close() }
        if outputStream[.SmallData] != nil { outputStream[.SmallData]!.close() }
        if outputStream[.LargeData] != nil { outputStream[.LargeData]!.close() }
        
        peripheral.haveOpenStreamsToCentral = false
        
    }
    
    // This is a callback from the streamer
    func disconnect() {
        print("Browser received disconnect")
        closeStreams()
        browsing = false
        if connectedVgcService != nil { peripheral.lostConnectionToCentral(connectedVgcService) }
        connectedVgcService = nil
    }
    
    func receivedNetServiceMessage(elementIdentifier: Int, elementValue: NSData) {
        
        // Get the element in the message using the hash value reference
        guard let element = elements.elementFromIdentifier(elementIdentifier) else {
            print("ERROR: Received unknown element identifier: \(elementIdentifier) from \(connectedVgcService.fullName)")
            return
        }
        
        element.valueAsNSData = elementValue
        
        switch (element.type) {
            
        case .SystemMessage:
            
            let systemMessageType = SystemMessages(rawValue: Int(element.value as! NSNumber))
            
            print("Central sent system message: \(systemMessageType!.description) to \(connectedVgcService.fullName)")
            
            if systemMessageType == .ConnectionAcknowledgement {
                
                dispatch_async(dispatch_get_main_queue()) {

                    if self.peripheral.connectionAcknowledgementWaitTimeout != nil { self.peripheral.connectionAcknowledgementWaitTimeout.invalidate() }
                    
                    self.peripheral.haveConnectionToCentral = true
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(VgcPeripheralDidConnectNotification, object: nil)
                    
                }
                
            } else {
            
                NSNotificationCenter.defaultCenter().postNotificationName(VgcSystemMessageNotification, object: systemMessageType!.rawValue)
                
            }
            
            break
            
        case .PeripheralSetup:
            
            NSKeyedUnarchiver.setClass(VgcPeripheralSetup.self, forClassName: "VgcPeripheralSetup")
            VgcManager.peripheralSetup = (NSKeyedUnarchiver.unarchiveObjectWithData(element.valueAsNSData) as! VgcPeripheralSetup)

            print("Central sent peripheral setup: \(VgcManager.peripheralSetup)")

            NSNotificationCenter.defaultCenter().postNotificationName(VgcPeripheralSetupNotification, object: nil)

            break
            
        case .PlayerIndex:

            let playerIndex = Int(element.value as! NSNumber)
            peripheral.playerIndex = GCControllerPlayerIndex(rawValue: playerIndex)!
            
            if deviceIsTypeOfBridge(){
                
                self.peripheral.controller.playerIndex = GCControllerPlayerIndex(rawValue: playerIndex)!
                
            }
            NSNotificationCenter.defaultCenter().postNotificationName(VgcNewPlayerIndexNotification, object: playerIndex)
            
        default:

            if !deviceIsTypeOfBridge() {
                
                // Call the handler set on the global object
                if let handler = element.valueChangedHandlerForPeripheral {
                    handler(element)
                }
            }
            
        }
        
        // If we're a bridge, send along the value to the Central
        if deviceIsTypeOfBridge() && element.type != .PlayerIndex {
            
            //peripheral.browser.sendElementStateOverNetService(element)
            peripheral.controller.sendElementStateToPeripheral(element)
            
        }
        
    }
    
    // Used by a Bridge to tell the Central that a Peripheral has disconnected.
    func disconnectFromCentral() {
        if connectedVgcService == nil { return }
        print("Browser sending system message Disconnect to \(connectedVgcService.fullName) from \(peripheral.controller.deviceInfo.vendorName)")
        elements.systemMessage.value = SystemMessages.Disconnect.rawValue
        sendElementStateOverNetService(elements.systemMessage)
        closeStreams()
    }
    
    // This is triggered by the Streamer if it receives a malformed message.  We just log it here.
    func sendInvalidMessageSystemMessage() {
        print("Peripheral received invalid checksum message from Central")
    }
    
    func sendDeviceInfoElement(let element: Element!) {
        
        if element == nil {
            print("Browser got attempt to send nil element to \(connectedVgcService.fullName)")
            return
        }
        
        var outputStreamLarge: NSOutputStream!
        var outputStreamSmall: NSOutputStream!
        
        if VgcManager.appRole == .Peripheral {
            outputStreamLarge = self.outputStream[.LargeData]
            outputStreamSmall = self.outputStream[.SmallData]
        } else if deviceIsTypeOfBridge() {
            outputStreamLarge = peripheral.controller.toCentralOutputStream[.LargeData]
            outputStreamSmall = peripheral.controller.toCentralOutputStream[.SmallData]
        }
        
        if peripheral.haveOpenStreamsToCentral {
            streamer[.LargeData]!.writeElement(element, toStream:outputStreamLarge)
            streamer[.SmallData]!.writeElement(element, toStream:outputStreamSmall)
        }
    }

    func sendElementStateOverNetService(let element: Element!) {
        
        if element == nil {
            print("Browser got attempt to send nil element to \(connectedVgcService.fullName)")
            return
        }
        
        var outputStream: NSOutputStream!
        
        if VgcManager.appRole == .Peripheral {
            if element.dataType == .Data {
                outputStream = self.outputStream[.LargeData]
            } else {
                outputStream = self.outputStream[.SmallData]
            }
        } else if deviceIsTypeOfBridge() {
            if element.dataType == .Data {
                outputStream = peripheral.controller.toCentralOutputStream[.LargeData]
            } else {
                outputStream = peripheral.controller.toCentralOutputStream[.SmallData]
            }
        }
    
        if outputStream == nil {
            if connectedVgcService != nil { print("\(connectedVgcService.fullName) failed to send element \(element.name) because we don't have an output stream") } else { print("Failed to send element \(element.name) because we don't have an output stream") }
            return
        }

        // Prevent writes without a connection except deviceInfo
        if element.dataType == .Data {
            if peripheral.haveConnectionToCentral || element.type == .DeviceInfoElement { streamer[.LargeData]!.writeElement(element, toStream:outputStream) }
        } else {
            if peripheral.haveConnectionToCentral || element.type == .DeviceInfoElement { streamer[.SmallData]!.writeElement(element, toStream:outputStream) }
        }
       
    }

    func reset() {
        print("Resetting service browser")
        serviceLookup.removeAll()
    }
    
    func browseForCentral() {
        
        if browsing {
        
            print("Not browsing for central because already browsing")
            return
        
        }
        
        browsing = true
        
        print("Searching for Centrals on \(VgcManager.bonjourTypeCentral)")
        centralBrowser = NSNetServiceBrowser()
        centralBrowser.includesPeerToPeer = VgcManager.includesPeerToPeer
        centralBrowser.delegate = self
        centralBrowser.searchForServicesOfType(VgcManager.bonjourTypeCentral, inDomain: "local")
        
        // We only searches for bridges if we are not type bridge (bridges don't connect to bridges)
        if !deviceIsTypeOfBridge() {
            print("Searching for Bridges on \(VgcManager.bonjourTypeBridge)")
            bridgeBrowser = NSNetServiceBrowser()
            bridgeBrowser.includesPeerToPeer = VgcManager.includesPeerToPeer
            bridgeBrowser.delegate = self
            bridgeBrowser.searchForServicesOfType(VgcManager.bonjourTypeBridge, inDomain: "local")
        }
    }
    
    func stopBrowsing() {
        print("Stopping browse for Centrals")
        centralBrowser.stop()
        print("Stopping browse for Bridges")
        if !deviceIsTypeOfBridge() { bridgeBrowser.stop() } // Bridges don't browse for Bridges
        print("Clearing service lookup")
        browsing = false
        serviceLookup.removeAll()
    }
    
    func openStreamsFor(streamDataType: StreamDataType, vgcService: VgcService) {

        print("Attempting to open \(streamDataType) streams for: \(vgcService.fullName)")
        var success: Bool
        var inStream: NSInputStream?
        var outStream: NSOutputStream?
        success = vgcService.netService.getInputStream(&inStream, outputStream: &outStream)
        if ( !success ) {
            
            print("Something went wrong connecting to service: \(vgcService.fullName)")
            NSNotificationCenter.defaultCenter().postNotificationName(VgcPeripheralConnectionFailedNotification, object: nil)
            
        } else {
            
            print("Successfully opened \(streamDataType) streams to service: \(vgcService.fullName)")
            
            connectedVgcService = vgcService
            
            if deviceIsTypeOfBridge() && peripheral.controller != nil {
                
                peripheral.controller.toCentralOutputStream[streamDataType] = outStream;
                peripheral.controller.toCentralOutputStream[streamDataType]!.delegate = streamer[streamDataType]
                peripheral.controller.toCentralOutputStream[streamDataType]!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
                peripheral.controller.toCentralOutputStream[streamDataType]!.open()
                
                peripheral.controller.fromCentralInputStream[streamDataType] = inStream
                peripheral.controller.fromCentralInputStream[streamDataType]!.delegate = streamer[streamDataType]
                peripheral.controller.fromCentralInputStream[streamDataType]!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
                peripheral.controller.fromCentralInputStream[streamDataType]!.open()
                
            } else {
                
                outputStream[streamDataType] = outStream;
                outputStream[streamDataType]!.delegate = streamer[streamDataType]
                outputStream[streamDataType]!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
                outputStream[streamDataType]!.open()
                
                inputStream[streamDataType] = inStream
                inputStream[streamDataType]!.delegate = streamer[streamDataType]
                inputStream[streamDataType]!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
                inputStream[streamDataType]!.open()
                
            }
            
            // SmallData comes second, so we wait for it before sending deviceInfo
            if streamDataType == .SmallData {
                
                peripheral.gotConnectionToCentral()
                
            }
            
        }
        
    }
    
    func connectToService(vgcService: VgcService) {
       
        if (peripheral.haveConnectionToCentral == true) {
            print("Refusing to connect to service \(vgcService.fullName) because we already have a connection.")
            return
        }
        
        print("Attempting to connect to service: \(vgcService.fullName)")
        
        openStreamsFor(.LargeData, vgcService: vgcService)
        openStreamsFor(.SmallData, vgcService: vgcService)
    }
    
    func netServiceBrowser(browser: NSNetServiceBrowser, didFindService service: NSNetService, moreComing: Bool) {
        if (service == localService) {
            print("Ignoring service because it is our own: \(service.name)")
        } else {
            print("Found service of type \(service.type) at \(service.name)")
            var vgcService: VgcService
            if service.type == VgcManager.bonjourTypeBridge {
                vgcService = VgcService(name: service.name, type:.Bridge, netService: service)
            } else {
                vgcService = VgcService(name: service.name, type:.Central, netService: service)
            }
            
            serviceLookup[service] = vgcService
            
            NSNotificationCenter.defaultCenter().postNotificationName(VgcPeripheralFoundService, object: vgcService)
            
            if deviceIsTypeOfBridge() && vgcService.type == .Central { connectToService(vgcService) }
        }
        
    }
    
    func netServiceBrowser(browser: NSNetServiceBrowser, didRemoveService service: NSNetService, moreComing: Bool) {
        
        print("Service was removed: \(service.type) isMainThread: \(NSThread.isMainThread())")
        let vgcService = serviceLookup.removeValueForKey(service)
        print("VgcService was removed: \(vgcService?.fullName)")
        // If VgcService is nil, it means we already removed the service so we do not send the notification
        if vgcService != nil { NSNotificationCenter.defaultCenter().postNotificationName(VgcPeripheralLostService, object: vgcService) }
        
    }

    func netServiceBrowserDidStopSearch(browser: NSNetServiceBrowser) {
        browsing = false
    }
    
    func netServiceBrowser(browser: NSNetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        print("Net service browser reports error \(errorDict)")
        browsing = false
    }
    
}
