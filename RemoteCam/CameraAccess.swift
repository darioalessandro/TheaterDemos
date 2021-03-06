//
//  CameraAccess.swift
//  Actors
//
//  Created by Dario Lencina on 11/2/15.
//  Copyright © 2015 dario. All rights reserved.
//

import Foundation
import Photos
import AVFoundation
import Theater

/**
Permissions verification extensions
*/

extension UIViewController {
    
    @objc public func verifyCameraAndCameraRollAccess() {
        verifyCameraRollAccess()
        verifyCameraAccess()
    }
    
    public func verifyCameraAccess() {
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) != .authorized {
            AVCaptureDevice.requestAccess( forMediaType: AVMediaTypeVideo) {
                if !$0 {
                    ^{self.showNoAccessToCamera()}
                }
            }
        }
    }
    
    public func verifyCameraRollAccess() {
        if PHPhotoLibrary.authorizationStatus() != .authorized {
            PHPhotoLibrary.requestAuthorization {
                if $0 != .authorized {
                    ^{self.showNoCameraRollAccess()}
                }
            }
        }
    }
    
    public func showNoAccessToCamera() {
        let fileName = "BFDeniedAccessToCameraView"
        let blocker = Bundle.main.loadNibNamed(fileName, owner: nil, options: nil)![0] as! UIView
        self.addErrorView(view: blocker)
    }
    
    public func addErrorView(view : UIView) {
        if let delegate = UIApplication.shared.delegate,
            let window = delegate.window {
                window!.addSubview(view)
                view.frame = (window?.bounds)!
            }
    }
    
    public func showNoCameraRollAccess() {
        let fileName = "BFDeniedAccessToAssetsView"
        let blocker = Bundle.main.loadNibNamed(fileName, owner: nil, options: nil)![0] as! UIView
        addErrorView(view: blocker)
    }
    
}
