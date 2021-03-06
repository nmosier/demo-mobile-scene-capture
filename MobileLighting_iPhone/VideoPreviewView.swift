//
//  VideoPreviewView.swift
//  demo
//
//  Created by Nicholas Mosier on 6/22/17.
//  Copyright © 2017 Nicholas Mosier. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPreviewView: UIView {
    @IBOutlet weak var focusPointLabel: UILabel!

    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    var session: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
            
        }
    }
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    private let orientationMap: [UIDeviceOrientation : AVCaptureVideoOrientation] = [
        .portrait : .portrait,
        .portraitUpsideDown : .portraitUpsideDown,
        .landscapeLeft : .landscapeRight,
        .landscapeRight: .landscapeLeft,
        .faceUp : .portrait,
        .faceDown : .portrait,
        .unknown : .portrait,
    ]
    
//    class OrientationObserver: NSObject {
//        @objc dynamic var
//    }
    
    func updateOrientation() -> AVCaptureVideoOrientation {
        let orientation = orientationMap[UIDevice.current.orientation]!
        if let connection = self.videoPreviewLayer.connection {
            if connection.isVideoOrientationSupported {
                connection.videoOrientation = orientation
            }
        }
        return orientation
    }

}
