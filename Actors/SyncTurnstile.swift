//
//  Turnstile.swift
//  Actors
//
//  Created by Dario Lencina on 11/7/15.
//  Copyright © 2015 dario. All rights reserved.
//

import UIKit
import Theater

class CoinModule  : ViewCtrlActor<SyncTurnstileViewController> {
    
    lazy var audioPlayer : ActorRef = self.actorOf(clz: AudioPlayer.self, name:"AudioPlayer")
    
    required init(context: ActorSystem, ref: ActorRef) {
        super.init(context: context, ref : ref)
    }
    
    override func receiveWithCtrl(ctrl: SyncTurnstileViewController) -> Receive {
        return withGate(gate: ctrl.gate, ctrl: ctrl)
    }
    
    func withGate(gate : ActorRef, ctrl: SyncTurnstileViewController) -> Receive {
        return { [unowned self](msg : Message) in
            switch(msg) {
            case is InsertCoin:
                self.audioPlayer ! AudioPlayer.PlaySound(sender: self.this, name: "coin", ext: "mp3")
                Thread.sleep(forTimeInterval: 0.5)
                gate ! Gate.Unlock(sender : self.this)
            default:
                self.receive(msg: msg)
            }
        }
    }
    
}

class Gate : ViewCtrlActor<SyncTurnstileViewController> {
    
    class States {
        let locked = "locked"
        let unlocked = "unlocked"
    }
    
    var states = States()
    
    lazy var audioPlayer : ActorRef = self.actorOf(clz: AudioPlayer.self, name:"AudioPlayer")
    
    required init(context: ActorSystem, ref: ActorRef) {
        super.init(context: context, ref : ref)
    }
    
    override func receiveWithCtrl(ctrl: SyncTurnstileViewController) -> Receive {
        return locked(ctrl: ctrl)
    }
    
    func locked(ctrl: SyncTurnstileViewController) -> Receive {
        ^{ctrl.status.text = "Turnstile is locked"}
        return {[unowned self] (msg : Message) in
            switch(msg) {
            case is Unlock:
                self.become(name: self.states.unlocked, state: self.unlocked(ctrl: ctrl, fares: 1), discardOld:true)
            case is Push:
                self.audioPlayer ! AudioPlayer.PlaySound(sender: self.this, name: "locked", ext: "mp3")
            default:
                self.receive(msg: msg)
            }
        }
    }
    
    func unlocked(ctrl: SyncTurnstileViewController, fares : UInt) -> Receive {
        ^{ctrl.status.text = "Turnstile is unlocked, fares = \(fares)"}
        return {[unowned self] (msg : Message) in
            switch(msg) {
            case is Unlock:
                self.become(name: self.states.unlocked, state: self.unlocked(ctrl: ctrl, fares: fares + 1), discardOld:true)
            case is Push:
                self.audioPlayer ! AudioPlayer.PlaySound(sender: self.this, name: "turnstile", ext: "mp3")
                if fares == 1 {
                    self.become(name: self.states.locked, state: self.locked(ctrl: ctrl), discardOld:true)
                } else {
                    self.become(name: self.states.unlocked, state: self.unlocked(ctrl: ctrl, fares: fares - 1), discardOld:true)
                }
            default:
                self.receive(msg: msg)
            }
        }
    }
    
}

class SyncTurnstileViewController : UIViewController {
    
    lazy var system : ActorSystem = ActorSystem(name : "Turnstile")
    
    lazy var coinModule : ActorRef = self.system.actorOf(clz: CoinModule.self, name:"CoinModule")
    
    lazy var gate : ActorRef = self.system.actorOf(clz: Gate.self, name: "Gate")
    
    @IBOutlet weak var status: UILabel!
    
    @IBAction func onPush(sender: UIButton) {
        gate ! Gate.Push(sender : nil)
    }
    
    @IBAction func onInsertCoin(sender: UIButton) {
        coinModule ! CoinModule.InsertCoin(sender : nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gate ! SetViewCtrl(ctrl:self)
        coinModule ! SetViewCtrl(ctrl:self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if self.isBeingDismissed || self.isMovingFromParent {
            system.stop()
        }
    }
    
}
