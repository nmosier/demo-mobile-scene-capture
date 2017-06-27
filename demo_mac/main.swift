//
//  main.swift
//  demo_mac
//
//  Created by Nicholas Mosier on 6/2/17.
//  Copyright © 2017 Nicholas Mosier. All rights reserved.
//

import Foundation
import Cocoa
import CoreFoundation
import CocoaAsyncSocket
import AVFoundation

import SwitcherCtrl
import VXMCtrl


var app = NSApplication.shared()


//MARK: global configuration variables
var cameraServiceBrowser: CameraServiceBrowser!
var photoReceiver: PhotoReceiver!
var displayController: DisplayController!   // includes switcher
var vxmController: VXMController!

var scenesDirectory = "/Users/nicholas/Desktop/scenes"
var sceneName: String = "test"
let minSWfilepath = "/Users/nicholas/OneDrive - Middlebury College/Summer Research 2017/MobileLighting/demo-mobile-scene-capture/minSW.dat"

var exposures: [Double]
var lensPosition: Float
var binaryCodeSystem: BinaryCodeSystem

//MARK: Utility functions
func initializeIPhoneCommunications() {
    cameraServiceBrowser = CameraServiceBrowser()
    photoReceiver = PhotoReceiver(scenesDirectory)
    
    photoReceiver.startBroadcast()
    cameraServiceBrowser.startBrowsing()
}

// waits for both photo receiver & camera service browser communications
// to be established
// NOTE: only call if you're sure it won't seize control of the program, e.g. it should be executed within a DispatchQueue!
func waitForEstablishedCommunications() {
    while !cameraServiceBrowser.readyToSendPacket {}
    while !photoReceiver.readyToReceive {}
}

func configureDisplays() -> Bool {
    displayController = DisplayController()
    guard NSScreen.screens()!.count > 1  else {
        print("Only one screen connected.")
        return false
    }
    
    for screen in NSScreen.screens()! {
        if screen != NSScreen.main()! {
            displayController.createNewWindow(on: screen)
        }
    }
    
    displayController.setCurrentScreen(withID: 0)   // set main secondary screen to be first in array
    return true
}


//MARK: execution body

binaryCodeSystem = .MinStripeWidthCode
sceneName = "scene"
exposures = [0.01, 0.02, 0.05, 0.1]

 initializeIPhoneCommunications()

if configureDisplays() {
    print("main: Successfully configured displays.")
} else {
    print("main: ERROR — failed to configure displays.")
}

let mainQueue = DispatchQueue(label: "mainQueue")
mainQueue.async {
    //displayController.windows.first!.configureDisplaySettings(horizontal: false, inverted: false)
    //displayController.windows.first!.displayBinaryCode(forBit: 0, system: .MinStripeWidthCode)
    
    //while nextCommand() {}
    
    waitForEstablishedCommunications()
    
    // lock white balance before capture
    let packet = CameraInstructionPacket(cameraInstruction: .LockWhiteBalance)
    cameraServiceBrowser.sendPacket(packet)
    
    var receivedUpdate = false
    photoReceiver.receiveStatusUpdate(completionHandler: {(update: CameraStatusUpdate) in receivedUpdate = true})
    while !receivedUpdate {}
    
    while nextCommand() {}
}

let appDelegate = AppDelegate()
NSApp.delegate = appDelegate
NSApp.run()

