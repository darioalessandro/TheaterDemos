//
//  MultipeerMessages.swift
//  Actors
//
//  Created by Dario on 10/7/15.
//  Copyright © 2015 dario. All rights reserved.
//

import Foundation
import Theater
import MultipeerConnectivity
import AVFoundation

public class Disconnect : Actor.Message {}

public class ConnectToDevice : Actor.Message {
    public let peer : MCPeerID
    
    public init(peer : MCPeerID, sender : Optional<ActorRef>) {
        self.peer = peer
        super.init(sender: sender)
    }
}

public class UICmd {
    
    public class BecomeMonitorFailed: Actor.Message {}
    
    public class FailedToSaveImage : Actor.Message {
        let error : NSError
        
        init(sender: Optional<ActorRef>, error : NSError) {
            self.error = error
            super.init(sender: sender)
        }
    }
    
    public class AddMonitor : Actor.Message {}
    
    public class AddImageView : Actor.Message {
        let imageView : UIImageView
        
        public required init(imageView : UIImageView) {
            self.imageView = imageView
            super.init(sender: nil)
        }
    }
    
    public class StartScanning : Actor.Message {}
    
    public class UnbecomeCamera : Actor.Message {}
    
    public class ToggleConnect : Actor.Message {}
    
    public class UnbecomeMonitor : Actor.Message {}
    
    public class BecomeMonitor : Actor.Message {}

    public class BecomeCamera : Actor.Message {
        let ctrl : CameraViewController
        
        public init(sender: Optional<ActorRef>, ctrl : CameraViewController) {
            self.ctrl = ctrl
            super.init(sender: sender)
        }
    }
    
    public class TakePicture : Actor.Message {}
    
    public class OnPicture : Actor.Message {
        
        public let pic : Optional<NSData>
        public let error : Optional<NSError>
        
        public init(sender: Optional<ActorRef>, pic : NSData) {
            self.pic = pic
            self.error = nil
            super.init(sender: sender)
        }
        
        public init(sender: Optional<ActorRef>, error : NSError) {
            self.pic = nil
            self.error = error
            super.init(sender: sender)
        }
    }
    
    public class ToggleFlash : Actor.Message, NSCoding {
        public init() {
            super.init(sender : nil)
        }
        
        public func encodeWithCoder(aCoder: NSCoder) {}
        
        public required init?(coder aDecoder: NSCoder) {
            super.init(sender: nil)
        }
    }
    
    public class ToggleFlashResp : Actor.Message, NSCoding {
        
        public let error : NSError?
        public let flashMode : AVCaptureFlashMode?
        
        public init(flashMode : AVCaptureFlashMode?, error : NSError?) {
            self.flashMode = flashMode
            self.error = error
            super.init(sender : nil)
        }
        
        public func encodeWithCoder(aCoder: NSCoder) {
            if let f = self.flashMode {
                aCoder.encodeInteger(f.rawValue, forKey: "flashMode")
            }
            
            if let e = self.error {
                aCoder.encodeObject(e, forKey: "error")
            }
        }
        
        public required init?(coder aDecoder: NSCoder) {
            self.flashMode = AVCaptureFlashMode(rawValue: aDecoder.decodeIntegerForKey("flashMode"))!
            self.error = aDecoder.decodeObjectForKey("error") as? NSError
            super.init(sender: nil)
        }
    }
    
    public class ToggleCamera : Actor.Message, NSCoding {
        public init() {
            super.init(sender : nil)
        }
        
        public func encodeWithCoder(aCoder: NSCoder) {}
        
        public required init?(coder aDecoder: NSCoder) {
            super.init(sender: nil)
        }
        
    }
    
    public class ToggleCameraResp : Actor.Message, NSCoding {
        
        public let error : NSError?
        public let flashMode : AVCaptureFlashMode?
        public let camPosition : AVCaptureDevicePosition?
        
        public init(flashMode : AVCaptureFlashMode?,
            camPosition : AVCaptureDevicePosition?,
            error : NSError?) {
                self.flashMode = flashMode
                self.camPosition = camPosition
                self.error = error
                super.init(sender : nil)
        }
        
        public func encodeWithCoder(aCoder: NSCoder) {
            if let flashMode = self.flashMode {
                aCoder.encodeInteger(flashMode.rawValue, forKey: "flashMode")
            }
            
            if let camPosition = self.camPosition {
                aCoder.encodeInteger(camPosition.rawValue, forKey: "camPosition")
            }
            
            if let e = self.error {
                aCoder.encodeObject(e, forKey: "error")
            }
        }
        
        public required init?(coder aDecoder: NSCoder) {
            self.flashMode = AVCaptureFlashMode(rawValue: aDecoder.decodeIntegerForKey("flashMode"))
            self.camPosition = AVCaptureDevicePosition(rawValue: aDecoder.decodeIntegerForKey("camPosition"))
            self.error = aDecoder.decodeObjectForKey("error") as? NSError
            
            super.init(sender: nil)
        }
    }
}

public class DisconnectPeer : Actor.Message {
    public let peer : MCPeerID
    
    public init(peer : MCPeerID, sender : Optional<ActorRef>) {
        self.peer = peer
        super.init(sender: sender)
    }
}

public class OnConnectToDevice : Actor.Message {
    public let peer : MCPeerID
    
    public init(peer : MCPeerID, sender : Optional<ActorRef>) {
        self.peer = peer
        super.init(sender: sender)
    }
}

public class RemoteCmd : Actor.Message {
    
    public class TakePic : RemoteCmd, NSCoding {
        
        public override init(sender: Optional<ActorRef>) {
            super.init(sender: sender)
        }
        
        public func encodeWithCoder(aCoder: NSCoder) {}
        
        public required init?(coder aDecoder: NSCoder) {
            super.init(sender: nil)
        }
        
    }
    
    public class TakePicAck : Actor.Message, NSCoding {
        
        public override init(sender: Optional<ActorRef>) {
            super.init(sender: sender)
        }
        
        public func encodeWithCoder(aCoder: NSCoder) {}
        
        public required init?(coder aDecoder: NSCoder) {
            super.init(sender: nil)
        }
    }
    
    public class TakePicResp : Actor.Message , NSCoding {
        
        let pic : Optional<NSData>
        let error : Optional<NSError>
        
        
        public func encodeWithCoder(aCoder: NSCoder) {
            if let pic = self.pic {
                aCoder.encodeDataObject(pic)
            }
            
            if let error = self.error {
                aCoder.encodeObject(error, forKey: "error")
            }
        }
        
        public required init?(coder aDecoder: NSCoder) {
            self.pic = aDecoder.decodeDataObject()
            
            //TOFIX: This could be a flatmap
            if let error = aDecoder.decodeObjectForKey("error") {
                self.error = error as? NSError
            }else {
                self.error = nil
            }
            
            super.init(sender: nil)
        }
        
        public init(sender: Optional<ActorRef>, pic : NSData) {
            self.pic = pic
            self.error = nil
            super.init(sender: sender)
        }
        
        public init(sender: Optional<ActorRef>, pic : Optional<NSData>, error : Optional<NSError>) {
            self.pic = pic
            self.error = error
            super.init(sender: sender)
        }
        
        public init(sender: Optional<ActorRef>, error : NSError) {
            self.pic = nil
            self.error = error
            super.init(sender: sender)
        }
    }
    
    public class SendFrame : Actor.Message, NSCoding {
        public let data : NSData
        public let fps : NSInteger
        public let camPosition : AVCaptureDevicePosition
        
        init(data : NSData, sender : Optional<ActorRef>, fps : NSInteger, camPosition : AVCaptureDevicePosition) {
            self.data = data
            self.fps = fps
            self.camPosition = camPosition
            super.init(sender: sender)
        }
        
        public func encodeWithCoder(aCoder: NSCoder) {
            aCoder.encodeDataObject(self.data)
            aCoder.encodeInteger(self.fps, forKey: "fps")
            aCoder.encodeInteger(self.camPosition.rawValue, forKey: "camPosition")
        }
        
        public required init?(coder aDecoder: NSCoder) {
            self.data = aDecoder.decodeDataObject()!
            self.fps = aDecoder.decodeIntegerForKey("fps")
            self.camPosition = AVCaptureDevicePosition(rawValue: aDecoder.decodeIntegerForKey("camPosition"))!
            super.init(sender: nil)
        }
    }
    
    public class OnFrame : Actor.Message {
        public let data : NSData
        public let peerId : MCPeerID
        public let fps : NSInteger
        public let camPosition : AVCaptureDevicePosition
        
        init(data : NSData, sender : Optional<ActorRef>, peerId : MCPeerID, fps:NSInteger, camPosition : AVCaptureDevicePosition) {
            self.camPosition = camPosition
            self.data = data
            self.peerId = peerId
            self.fps = fps
            super.init(sender: sender)
        }
    }
    
    public class PeerBecameCamera : Actor.Message , NSCoding {
        
        public init() {
            super.init(sender : nil)
        }
        
        public func encodeWithCoder(aCoder: NSCoder) {}
        
        public required init?(coder aDecoder: NSCoder) {
            super.init(sender: nil)
        }
    }
    
    public class PeerBecameMonitor : Actor.Message , NSCoding {
        
        public init() {
            super.init(sender : nil)
        }
        
        public func encodeWithCoder(aCoder: NSCoder) {}
        
        public required init?(coder aDecoder: NSCoder) {
            super.init(sender: nil)
        }
    }
    
    public class ToggleFlash : Actor.Message, NSCoding {
        public init() {
            super.init(sender : nil)
        }
        
        public func encodeWithCoder(aCoder: NSCoder) {}
        
        public required init?(coder aDecoder: NSCoder) {
            super.init(sender: nil)
        }
    }
    
    public class ToggleFlashResp : Actor.Message, NSCoding {
        
        public let error : NSError?
        public let flashMode : AVCaptureFlashMode?
        
        public init(flashMode : AVCaptureFlashMode?, error : NSError?) {
            self.flashMode = flashMode
            self.error = error
            super.init(sender : nil)
        }
        
        public func encodeWithCoder(aCoder: NSCoder) {
            if let f = self.flashMode {
                aCoder.encodeInteger(f.rawValue, forKey: "flashMode")
            }
            
            if let e = self.error {
                aCoder.encodeObject(e, forKey: "error")
            }
        }
        
        public required init?(coder aDecoder: NSCoder) {
            self.error = aDecoder.decodeObjectForKey("error") as? NSError
            if let _ = self.error {
                self.flashMode = nil
            } else {
               self.flashMode = AVCaptureFlashMode(rawValue: aDecoder.decodeIntegerForKey("flashMode"))!
            }
            super.init(sender: nil)
        }
    }
    
    public class ToggleCamera : Actor.Message, NSCoding {
        public init() {
            super.init(sender : nil)
        }
        
        public func encodeWithCoder(aCoder: NSCoder) {}
        
        public required init?(coder aDecoder: NSCoder) {
            super.init(sender: nil)
        }
        
    }
    
    public class ToggleCameraResp : Actor.Message, NSCoding {
        
        public let error : NSError?
        public let flashMode : AVCaptureFlashMode?
        public let camPosition : AVCaptureDevicePosition?
        
        public init(flashMode : AVCaptureFlashMode?,
            camPosition : AVCaptureDevicePosition?,
            error : NSError?) {
            self.flashMode = flashMode
            self.camPosition = camPosition
            self.error = error
            super.init(sender : nil)
        }
        
        public func encodeWithCoder(aCoder: NSCoder) {
            if let flashMode = self.flashMode {
                aCoder.encodeInteger(flashMode.rawValue, forKey: "flashMode")
            }
            
            if let camPosition = self.camPosition {
                aCoder.encodeInteger(camPosition.rawValue, forKey: "camPosition")
            }
            
            if let e = self.error {
                aCoder.encodeObject(e, forKey: "error")
            }
        }
        
        public required init?(coder aDecoder: NSCoder) {
            self.error = aDecoder.decodeObjectForKey("error") as? NSError
            
            if let _ = self.error {
                self.flashMode = nil
                self.camPosition = nil
            } else {
                self.flashMode = AVCaptureFlashMode(rawValue: aDecoder.decodeIntegerForKey("flashMode"))
                self.camPosition = AVCaptureDevicePosition(rawValue: aDecoder.decodeIntegerForKey("camPosition"))

            }
            
            
            super.init(sender: nil)
        }
    }
}



