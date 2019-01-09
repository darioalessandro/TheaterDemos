//
//  RemoteCommandBuilder.swift
//  Actors
//
//  Created by Dario Talarico on 1/7/19.
//  Copyright © 2019 dario. All rights reserved.
//

import Foundation
import AVFoundation

enum RemoteCommandBuilderError: Error {
    case unknownCommand
}

func map(value: RemoteShutterTypes.AVCaptureDevicePosition) -> AVCaptureDevicePosition {
    switch(value) {
    case .back:
        return AVCaptureDevicePosition.back
    case .front:
        return AVCaptureDevicePosition.front
    default:
        return AVCaptureDevicePosition.unspecified
    }
}

func map(value: AVCaptureDevicePosition) -> RemoteShutterTypes.AVCaptureDevicePosition {
    switch(value) {
    case .back:
        return RemoteShutterTypes.AVCaptureDevicePosition.back
    case .front:
        return RemoteShutterTypes.AVCaptureDevicePosition.front
    default:
        return RemoteShutterTypes.AVCaptureDevicePosition.unspecified
    }
}

func map(value: AVCaptureFlashMode) -> RemoteShutterTypes.AVCaptureFlashMode {
    switch(value) {
    case .auto:
        return RemoteShutterTypes.AVCaptureFlashMode.auto
    case .on:
        return RemoteShutterTypes.AVCaptureFlashMode.on
    default:
        return RemoteShutterTypes.AVCaptureFlashMode.off
    }
}

func map(value: RemoteShutterTypes.AVCaptureFlashMode) -> AVCaptureFlashMode {
    switch(value) {
    case .auto:
        return AVCaptureFlashMode.auto
    case .on:
        return AVCaptureFlashMode.on
    default:
        return AVCaptureFlashMode.off
    }
}

class RemoteCommandBuilder {
    
    public static let shared = RemoteCommandBuilder()
    
    public func buildWith(payload: Any) throws -> RemoteShutterEnvelope {
        switch payload {
        case let a as TakePic:
            return RemoteShutterEnvelope.with {
                $0.takePic = a
                $0.contentType = RemoteShutterEnvelope.ContentType.takePic
            }
        case let a as TakePicAck:
            return RemoteShutterEnvelope.with {
                $0.takePicAck = a
                $0.contentType = RemoteShutterEnvelope.ContentType.takePicAck
            }
        case let a as TakePicResp:
            return RemoteShutterEnvelope.with {
                $0.takePicResp = a
                $0.contentType = RemoteShutterEnvelope.ContentType.takePicResp
            }
        case let a as ToggleFlash:
            return RemoteShutterEnvelope.with {
                $0.toggleFlash = a
                $0.contentType = RemoteShutterEnvelope.ContentType.toggleFlash
            }
        case let a as ToggleFlashResp:
            return RemoteShutterEnvelope.with {
                $0.toggleFlashResp = a
                $0.contentType = RemoteShutterEnvelope.ContentType.toggleFlashResp
            }
        case let a as TakePicResp:
            return RemoteShutterEnvelope.with {
                $0.takePicResp = a
                $0.contentType = RemoteShutterEnvelope.ContentType.takePicResp
            }
        case let a as ToggleCamera:
            return RemoteShutterEnvelope.with {
                $0.toggleCamera = a
                $0.contentType = RemoteShutterEnvelope.ContentType.toggleCamera
            }
        case let a as ToggleCameraResp:
            return RemoteShutterEnvelope.with {
                $0.toggleCameraResp = a
                $0.contentType = RemoteShutterEnvelope.ContentType.toggleCameraResp
            }
        case let a as SendFrame:
            return RemoteShutterEnvelope.with {
                $0.sendFrame = a
                $0.contentType = RemoteShutterEnvelope.ContentType.sendFrame
            }
        case let a as PeerBecameCamera:
            return RemoteShutterEnvelope.with {
                $0.peerBecameCamera = a
                $0.contentType = RemoteShutterEnvelope.ContentType.peerBecameCamera
            }
        case let a as PeerBecameMonitor:
            return RemoteShutterEnvelope.with {
                $0.peerBecameMonitor = a
                $0.contentType = RemoteShutterEnvelope.ContentType.peerBecameMonitor
            }
        default:
            throw RemoteCommandBuilderError.unknownCommand
        }
    }
    
    public func serialize(payload: Any) throws -> Data {
        let envelope = try buildWith(payload: payload)
        return try envelope.serializedData()
    }
    
    public func deserialize(serializedData: Data) throws -> Any {
        let envelope = try RemoteShutterEnvelope(serializedData: serializedData)
        switch envelope.contentType {
        case RemoteShutterEnvelope.ContentType.takePic:
            return envelope.takePic
        case RemoteShutterEnvelope.ContentType.takePicAck:
            return envelope.takePicAck
        case RemoteShutterEnvelope.ContentType.takePicResp:
            return envelope.takePicResp
        case RemoteShutterEnvelope.ContentType.toggleFlash:
            return envelope.toggleFlash
        case RemoteShutterEnvelope.ContentType.toggleFlashResp:
            return envelope.toggleFlashResp
        case RemoteShutterEnvelope.ContentType.toggleCamera:
            return envelope.toggleCamera
        case RemoteShutterEnvelope.ContentType.toggleCameraResp:
            return envelope.toggleCameraResp
        case RemoteShutterEnvelope.ContentType.sendFrame:
            return envelope.sendFrame
        case RemoteShutterEnvelope.ContentType.peerBecameCamera:
            return envelope.peerBecameCamera
        case RemoteShutterEnvelope.ContentType.peerBecameMonitor:
            return envelope.peerBecameMonitor
        default:
            throw RemoteCommandBuilderError.unknownCommand
        }
    }
    
}
