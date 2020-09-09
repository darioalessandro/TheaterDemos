//
//  GreetingActor.swift
//  Actors
//
//  Created by Dario Lencina on 11/9/15.
//  Copyright © 2015 dario. All rights reserved.
//

import Foundation
import Theater

class Greeting : Actor.Message {}
class Angry : Actor.Message {}
class Happy : Actor.Message {}

class GreetingActor: ViewCtrlActor<GreetingActorController> {
    
    required init(context: ActorSystem, ref: ActorRef) {
        super.init(context: context, ref: ref)
    }
    
    override func receiveWithCtrl(ctrl: GreetingActorController) -> Receive {
        return self.happy(ctrl: ctrl)
    }
    
    func happy(ctrl: GreetingActorController) -> Receive { return {[unowned self](msg : Message) in
            switch(msg) {
            case is Greeting:
                ^{ctrl.say(msg: "Hello")}
                
            case is Angry:
                ^{ctrl.title = "Actor is Angry"
                    ctrl.rotateMouthToAngry()
                }
                self.become(name: "angry", state: self.angry(ctrl: ctrl), discardOld: true)
            
            default:
                self.receive(msg: msg)
            }
        }
    }
    
    func angry(ctrl: GreetingActorController)  -> Receive { return {[unowned self](msg : Message) in
            switch(msg) {
            case is Greeting:
                ^{ctrl.say(msg: "Go away ")}
                
            case is Happy:
                ^{ctrl.title = "Actor is Happy"
                    ctrl.rotateMouthToHappy()
                }
                self.become(name: "happy", state: self.happy(ctrl: ctrl), discardOld: true)
                
            default:
                self.receive(msg: msg)
            }
        }
    }
    
}

class GreetingActorController : UIViewController {
    
    lazy var system : ActorSystem = ActorSystem(name : "GreetingActorController")
    
    lazy var greetingActor : ActorRef = self.system.actorOf(clz: GreetingActor.self, name:"GreetingActor")
    
    @IBOutlet weak var mouth : UIImageView!
    
    @IBAction func sayHi() {
        greetingActor ! Greeting(sender: nil)
    }
    
    @IBAction func sendAngry() {
        greetingActor ! Angry(sender: nil)
    }
    
    @IBAction func sendHappy() {
        greetingActor ! Happy(sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        greetingActor ! SetViewCtrl(ctrl: self)
        greetingActor ! Angry(sender: nil)
        self.navigationController?.isToolbarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.isBeingDismissed || self.isMovingFromParent {
            system.stop()
            self.navigationController?.isToolbarHidden = true
        }
    }
    
    func say(msg : String) {
        let alert : UIAlertController = UIAlertController(title: "Actor says:", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true,completion: nil)
    }
    
    func rotateMouthToAngry() {
        UIView.animate(withDuration: 0.3, animations: {
            self.mouth.transform = __CGAffineTransformMake(1, 0, 0, 1, 0, 0)
            }, completion: nil)
    }
    
    func rotateMouthToHappy() {
        UIView.animate(withDuration: 0.3, animations: {
            self.mouth.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }, completion: nil)
        
    }
    
    
}
