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
        let error : Error
        
        init(sender: Optional<ActorRef>, error : Error) {
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
        
        public let pic : Optional<Data>
        public let error : Optional<Error>
        
        public init(sender: Optional<ActorRef>, pic : Data) {
            self.pic = pic
            self.error = nil
            super.init(sender: sender)
        }
        
        public init(sender: Optional<ActorRef>, error : Error) {
            self.pic = nil
            self.error = error
            super.init(sender: sender)
        }
    }
    
    public class ToggleFlash : Actor.Message {
        
        public init() {
            super.init(sender : nil)
        }
        
    }
    
    public class ToggleFlashResp : Actor.Message {
        
        public let error : Error?
        public let flashMode : AVCaptureFlashMode?
        
        public init(flashMode : AVCaptureFlashMode?, error : Error?) {
            self.flashMode = flashMode
            self.error = error
            super.init(sender : nil)
        }
    }
    
    public class ToggleCamera : Actor.Message {
        
        public init() {
            super.init(sender : nil)
        }
        
    }
    
    public class ToggleCameraResp : Actor.Message {
        
        public let error : Error?
        public let flashMode : AVCaptureFlashMode?
        public let camPosition : AVCaptureDevicePosition?
        
        public init(flashMode : AVCaptureFlashMode?,
                    camPosition : AVCaptureDevicePosition?,
                    error : Error?) {
            self.flashMode = flashMode
            self.camPosition = camPosition
            self.error = error
            super.init(sender : nil)
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
    
    public class OnRemoteCommand : Actor.Message {
        public let cmd : Any
        init(cmd : Any, sender: Optional<ActorRef>) {
            self.cmd = cmd
            super.init(sender: sender)
        }
    }
    
    public class OnFrame : Actor.Message {
        public let data : Data
        public let peerId : MCPeerID
        public let fps : NSInteger
        public let camPosition : AVCaptureDevicePosition
        
        init(data : Data, sender : Optional<ActorRef>, peerId : MCPeerID, fps:NSInteger, camPosition : AVCaptureDevicePosition) {
            self.camPosition = camPosition
            self.data = data
            self.peerId = peerId
            self.fps = fps
            super.init(sender: sender)
        }
    }
}



