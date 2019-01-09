//
//  SessionMonitorStates.swift
//  Actors
//
//  Created by Dario Lencina on 11/1/15.
//  Copyright © 2015 dario. All rights reserved.
//

import Foundation
import Theater
import MultipeerConnectivity

extension RemoteCamSession {
    
    func monitorTogglingFlash(monitor : ActorRef,
        peer : MCPeerID,
        lobby : RolePickerController) -> Receive {
            let alert = UIAlertController(title: "Requesting flash toggle",
                message: nil,
                preferredStyle: .alert)
            return {[unowned self] (msg : Actor.Message) in
                switch(msg) {
                    
                case is UICmd.ToggleFlash:
                    ^{lobby.present(alert, animated: true, completion: {
                        if let f = self.sendMessage(peer: [peer], msg: ToggleFlash()) as? Failure {
                            self.this ! RemoteCmd.OnRemoteCommand(cmd:ToggleFlashResp.with {
                                $0.error = (f.error?.localizedDescription)!
                            }, sender: nil)
                        }
                    })}
                    
                case let m as RemoteCmd.OnRemoteCommand:
                    switch(m.cmd) {
                    case let t as ToggleFlashResp:
//                        monitor ! UICmd.ToggleFlashResp(flashMode: map(value:t.flashMode), error: t.error)
                        monitor ! UICmd.ToggleFlashResp(flashMode: Optional.some(map(value:t.flashMode)), error: nil)
                    if t.hasFlashMode {
                        monitor ! m
                        ^{alert.dismiss(animated: true, completion: nil)}
                    }else if t.hasError {
                        ^{alert.dismiss(animated: true, completion:{
//                            let a = UIAlertController(title: error._domain, message: nil, preferredStyle: .alert)
                            let a = UIAlertController(title: t.error, message: nil, preferredStyle: .alert)
                            a.addAction(UIAlertAction(title: "Ok", style: .cancel) { (action) in
                                a.dismiss(animated: true, completion: nil)
                            })
                            lobby.present(a, animated: true, completion: nil)
                        })}
                    }
                    default:
                        print("message unhandled")
                    }
                    self.unbecome()
                    
                case let c as DisconnectPeer:
                    if c.peer.displayName == peer.displayName {
                        ^{alert.dismiss(animated: true, completion: nil)}
                        self.popAndStartScanning()
                    }
                    
                case is Disconnect:
                    ^{alert.dismiss(animated: true, completion: nil)}
                    self.popAndStartScanning()
                    
                case is UICmd.UnbecomeMonitor:
                    ^{alert.dismiss(animated: true, completion: nil)}
                    self.popToState(name: self.states.connected)
                    
                default:
                    print("sdfsdf")
                }
            }
    }
    
    func monitorTogglingCamera(monitor : ActorRef,
        peer : MCPeerID,
        lobby : RolePickerController) -> Receive {
            let alert = UIAlertController(title: "Requesting camera toggle",
                message: nil,
                preferredStyle: .alert)
            
            return {[unowned self] (msg : Actor.Message) in
                switch(msg) {
                    
                case is UICmd.ToggleCamera:
                    ^{lobby.present(alert, animated: true, completion: {
                        if let f =  self.sendMessage(peer: [peer], msg: ToggleCamera()) as? Failure {
                            self.this ! RemoteCmd.OnRemoteCommand(cmd:ToggleCameraResp.with {
                                $0.error = f.error.debugDescription
                            }, sender: nil)
                        }
                    })}
                    
                case let m as RemoteCmd.OnRemoteCommand:
                    switch(m.cmd) {
                    case let t as ToggleCameraResp:
                        //monitor ! UICmd.ToggleCameraResp(flashMode: map(value:t.flashMode), camPosition: map(value:t.camPosition), error: t.error)
                        monitor ! UICmd.ToggleCameraResp(flashMode: map(value:t.flashMode), camPosition: map(value:t.camPosition), error: nil)
                        if t.hasFlashMode {
                            ^{alert.dismiss(animated: true, completion: nil)}
                        }else if t.hasError {
                            ^{alert.dismiss(animated: true, completion:{
                                let a = UIAlertController(title: t.error, message: nil, preferredStyle: .alert)
                                a.addAction(UIAlertAction(title: "Ok", style: .cancel) { (action) in
                                    a.dismiss(animated: true, completion: nil)
                                })
                                lobby.present(a, animated: true, completion: nil)
                            })}
                        }
                        self.unbecome()
                    default:
                        print("error")
                    }
                
                case let c as DisconnectPeer:
                    if c.peer.displayName == peer.displayName {
                        ^{alert.dismiss(animated: true, completion: nil)}
                        self.popAndStartScanning()
                    }
                    
                case is Disconnect:
                    ^{alert.dismiss(animated: true, completion: nil)}
                    self.popAndStartScanning()
                    
                case is UICmd.UnbecomeMonitor:
                    ^{alert.dismiss(animated: true, completion: nil)}
                    self.popToState(name: self.states.connected)
                    
                default:
                    print("sdfsdf")
                }
            }
    }
    
    func monitorTakingPicture(monitor : ActorRef,
        peer : MCPeerID,
        lobby : RolePickerController) -> Receive {
            let alert = UIAlertController(title: "Requesting picture",
                message: nil,
                preferredStyle: .alert)
            return {[unowned self] (msg : Actor.Message) in
                switch(msg) {
                case let m as RemoteCmd.OnRemoteCommand:
                    switch (m.cmd) {
                    case is TakePicAck:
                        ^{alert.title = "Receiving picture"}
                        self.sendMessage(peer: [peer], msg: m.cmd)
                        
                    case let picResp as TakePicResp:
                        if picResp.hasPic, let image = UIImage(data: picResp.pic) {
                            UIImageWriteToSavedPhotosAlbum(image, self, Selector("image:didFinishSavingWithError:contextInfo:"), nil)
                            ^{alert.dismiss(animated: true, completion: nil)}
                        }else if picResp.hasError {
                            ^{alert.dismiss(animated: true, completion:{ () in
//                                let a = UIAlertController(title: error._domain, message: nil, preferredStyle: .alert)
                                let a = UIAlertController(title: picResp.error, message: nil, preferredStyle: .alert)
                                a.addAction(UIAlertAction(title: "Ok", style: .cancel) { (action) in
                                    a.dismiss(animated: true, completion: nil)
                                })
                                
                                lobby.present(a, animated: true, completion: nil)
                            })}
                        }
                        self.unbecome()
                    default:
                        print("error")
                    }
                    
                case is UICmd.TakePicture:
                    ^{lobby.present(alert, animated: true, completion: {
                        self.sendMessage(peer: [peer], msg: TakePic())
                    })}
                    
                case is UICmd.UnbecomeMonitor:
                    ^{alert.dismiss(animated: true, completion: nil)}
                    self.popToState(name: self.states.connected)
                    
                case let c as DisconnectPeer:
                    if c.peer.displayName == peer.displayName {
                        ^{alert.dismiss(animated: true, completion: nil)}
                        self.popAndStartScanning()
                    }
                    
                case is Disconnect:
                    ^{alert.dismiss(animated: true, completion: nil)}
                    self.popAndStartScanning()
                    
                default:
                    ^{alert.dismiss(animated: true, completion: nil)}
                    print("error")
                }
            }
    }
    
    func monitor(monitor : ActorRef,
        peer : MCPeerID,
        lobby : RolePickerController) -> Receive {
            return {[unowned self] (msg : Actor.Message) in
                switch(msg) {
                case is RemoteCmd.OnFrame:
                    monitor ! msg
                    
                case is UICmd.UnbecomeMonitor:
                    self.popToState(name: self.states.connected)
                    
                case let c as DisconnectPeer:
                    if c.peer.displayName == peer.displayName {
                        self.popAndStartScanning()
                    }
                    
                case is UICmd.ToggleCamera:
                    self.become(name: self.states.monitorTakingPicture, state:
                        self.monitorTogglingCamera(monitor: monitor, peer: peer, lobby: lobby))
                    self.this ! msg
                    
                case is UICmd.ToggleFlash:
                    self.become(name: self.states.monitorTogglingFlash, state:
                        self.monitorTogglingFlash(monitor: monitor, peer: peer, lobby: lobby))
                    self.this ! msg
                    
                case is UICmd.TakePicture:
                    self.become(name: self.states.monitorTakingPicture, state:
                        self.monitorTakingPicture(monitor: monitor, peer: peer, lobby: lobby))
                    self.this ! msg
                    
                case is Disconnect:
                    self.popAndStartScanning()
                    
                default:
                    self.receive(msg: msg)
                }
            }
    }
}
