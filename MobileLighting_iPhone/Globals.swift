//
//  File.swift
//  MobileLighting_iPhone
//
//  Created by Nicholas Mosier on 5/31/18.
//  Copyright © 2018 Nicholas Mosier. All rights reserved.
//

import Foundation
import AVFoundation

var cameraService: CameraService!
var cameraController = CameraController()
var photoSender: PhotoSender = PhotoSender()
var sceneMetadata = SceneMetadata()
var decoder: Decoder?
var motionRecorder = MotionRecorder()

var orientation: AVCaptureVideoOrientation!
var orientationObserver: NSKeyValueObservation!
