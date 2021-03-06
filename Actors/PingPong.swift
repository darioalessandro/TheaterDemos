//
//  PingPong.swift
//  Actors
//
//  Created by Dario Lencina on 11/9/15.
//  Copyright © 2015 dario. All rights reserved.
//

import Foundation
import Theater

class Ball : Actor.Message {}

class Ping : Actor {
    
    var counter = 0
    
    override func receive(msg: Actor.Message) {
        switch(msg) {
            case is Ball:
                counter += 1
                print("ping counter: \(counter)")
                Thread.sleep(forTimeInterval: 1) //Never sleep in an actor, this is for demo!
                self.sender! ! Ball(sender: this)
            
            default:
                super.receive(msg: msg)
        }
    }
}

class Pong : Actor {
    var counter = 0
    
    override func receive(msg: Actor.Message) {
        switch(msg) {
        case is Ball:
            counter += 1
            print("pong counter: \(counter)")
            Thread.sleep(forTimeInterval: 1) //Never sleep in an actor, this is for demo!
            self.sender! ! Ball(sender: this)
            
        default:
            super.receive(msg: msg)
        }
    }
}

public class PingPong {
    
    let system = ActorSystem(name: "pingpong")
    let ping : ActorRef
    let pong : ActorRef
    
    public init() {
        self.ping = system.actorOf(clz: Ping.self, name: "ping")
        self.pong = system.actorOf(clz: Pong.self, name: "pong")
        kickOffGame()
    }
    
    func kickOffGame() {
        pong ! Ball(sender: ping)
    }
    
}
