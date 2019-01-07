//
//  EnumExtensions.swift
//  Actors
//
//  Created by Dario Lencina on 11/3/15.
//  Copyright © 2015 dario. All rights reserved.
//

import Foundation
import AVFoundation
import Theater

extension AVCaptureDevicePosition {
    public func toggle() -> Try<AVCaptureDevicePosition> {
        switch(self) {
        case .back:
            return Success(value: .front)
        case .front:
            return Success(value: .back)
        default:
            return Failure(error: NSError(domain: "Unable to find camera position", code: 0, userInfo: nil))
        }
    }
}

extension AVCaptureFlashMode {
    public func next() -> AVCaptureFlashMode {
        switch(self) {
        case .off:
            return .on
        case .on:
            return .auto
        case .auto:
            return .off
        }
    }
}
