//
//  RemoteCamSessionCamStates.swift
//  Actors
//
//  Created by Dario Lencina on 11/1/15.
//  Copyright © 2015 dario. All rights reserved.
//

import Foundation
import Theater
import MultipeerConnectivity
import SwiftProtobuf

extension RemoteCamSession {
    
    func cameraTakingPic(peer : MCPeerID,
        ctrl : CameraViewController,
        lobby : RolePickerController) -> Receive {
            let alert = UIAlertController(title: "Taking picture",
                message: nil,
                preferredStyle: .alert)
            
        ^{lobby.present(alert, animated: true, completion: nil)}
            
            return {[unowned self] (msg : Actor.Message) in
                switch(msg) {
                    
                case let t as UICmd.OnPicture:
                    
                    if let imageData = t.pic,
                        let image = UIImage(data: imageData) {
                        UIImageWriteToSavedPhotosAlbum(image, self, Selector("image:didFinishSavingWithError:contextInfo:"), nil)
                    }
                    
                    ^{alert.dismiss(animated: true, completion: nil)}
                    
                    self.sendMessage(peer: [peer], msg: TakePicAck())
                    
                    let result = self.sendMessage(peer: [peer], msg: TakePicResp.with {
                        $0.pic = t.pic ?? SwiftProtobuf.Internal.emptyData
                        $0.error = t.error.debugDescription
                    })
                    
                    if let failure = result as? Failure {
                        ^{
                            let a = UIAlertController(title: "Error sending picture",
                                                      message: failure.error.debugDescription,
                                                      preferredStyle: .alert)
                            
                            a.addAction(UIAlertAction(title: "Ok", style: .cancel) { (action) in
                                a.dismiss(animated: true, completion: nil)
                                })
                            
                            ctrl.present(a, animated: true, completion: nil)
                        }
                    }
                    
                    self.unbecome()
                    
                case let c as DisconnectPeer:
                    ^{alert.dismiss(animated: true, completion: nil)}
                    if (c.peer.displayName == peer.displayName) {
                        self.popAndStartScanning()
                    }
                    
                case is Disconnect:
                    ^{alert.dismiss(animated: true, completion: nil)}
                    self.popAndStartScanning()
                    
                case is UICmd.UnbecomeCamera:
                    ^{alert.dismiss(animated: true, completion: nil)}
                    self.popAndStartScanning()
                    
                default:
                    self.receive(msg: msg)
                }
            }
    }
    
    func camera(peer : MCPeerID,
        ctrl : CameraViewController,
        lobby : RolePickerController) -> Receive {
            return {[unowned self] (msg : Actor.Message) in
                switch(msg) {
                case let m as UICmd.ToggleCameraResp:
                    self.sendMessage(peer: [peer], msg: ToggleCameraResp.with {
                        $0.flashMode = map(value: m.flashMode ?? AVCaptureFlashMode.off)
                        $0.camPosition = map(value: m.camPosition ?? AVCaptureDevicePosition.unspecified)
                    })
                    
                case let cmd as RemoteCmd.OnRemoteCommand:
                switch (cmd.cmd) {
                case let s as SendFrame:
                    self.sendMessage(peer: [peer], msg: s, mode: .unreliable)
                    
                case is TakePic:
                    ^{ctrl.takePicture()}
                    self.become(name: self.states.cameraTakingPic,
                                state:self.cameraTakingPic(peer: peer, ctrl: ctrl, lobby : lobby))
                    
                case is ToggleCamera:
                    let result = ctrl.toggleCamera()
                    if let (flashMode, camPosition) = result.toOptional() {
                        self.sendMessage(peer: [peer], msg: ToggleCameraResp.with {
                            $0.camPosition = map(value:camPosition)
                            $0.flashMode = map(value:flashMode ?? AVCaptureFlashMode.off)
                        })
                    } else if let failure = result as? Failure {
                        self.sendMessage(peer: [peer], msg: ToggleCameraResp.with {
                            $0.error = failure.error.debugDescription
                        })
                    }
                    
                case is ToggleFlash:
                    let result = ctrl.toggleFlash()
                    if let flashMode = result.toOptional() {
                        self.sendMessage(peer: [peer], msg: ToggleFlashResp.with {
                            $0.flashMode = map(value:flashMode)
                        })
                    } else if let failure = result as? Failure {
                        self.sendMessage(peer: [peer], msg:ToggleFlashResp.with {
                            $0.error = failure.error.debugDescription
                        })
                    }
                default:
                    print("error")
                    }
                    
                case is UICmd.UnbecomeCamera:
                    self.popToState(name: self.states.connected)
                    
                case let c as DisconnectPeer:
                    if (c.peer.displayName == peer.displayName) {
                        self.popAndStartScanning()
                    }
                    
                case is Disconnect:
                    self.popAndStartScanning()
                    
                default:
                    self.receive(msg: msg)
                }
            }
    }

}
