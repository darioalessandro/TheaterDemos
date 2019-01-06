//
//  PeripheralActor.swift
//  Actors
//
//  Created by Dario Lencina on 10/24/15.
//  Copyright © 2015 dario. All rights reserved.
//

import Foundation
import Theater
import CoreBluetooth



public extension PeripheralActor {
    
    public class OnClick : Actor.Message {}
    
    public class ToggleAdvertising : Actor.Message {}
    
}

public class PeripheralActor : ViewCtrlActor<PeripheralViewController>, WithListeners {
    
    public var listeners : [ActorRef] = []
    
    var onClickCharacteristic = CBMutableCharacteristic(type:  BLEData().characteristic, properties: [.read , .notifyEncryptionRequired, .write], value: nil, permissions: [.readEncryptionRequired, .writeEncryptionRequired])
    
    struct States {
        let connected = "connected"
        let advertising = "advertising"
    }
    
    private let states : States = States()
    
    let advertisementData : [String : AnyObject] = [CBAdvertisementDataIsConnectable : true as AnyObject,
                                                    CBAdvertisementDataLocalNameKey : "TheaterDemo" as AnyObject,
                                                    CBAdvertisementDataServiceUUIDsKey : [BLEData().svc] as AnyObject]
    
    lazy var peripheral : ActorRef = self.actorOf(clz: BLEPeripheral.self, name: "BLEPeripheral")
    
    required public init(context: ActorSystem, ref: ActorRef) {
        super.init(context: context, ref: ref)
    }
    
    func CBStateToString(state : CBPeripheralManagerState) -> String {
        switch(state) {
        case .unknown:
                return "Unknown"
        case .resetting:
                return "Resetting"
        case .unsupported:
                return "Unsupported"
        case .unauthorized:
                return "Unauthorized"
        case .poweredOff:
                return "PoweredOff"
        case .poweredOn:
                return "PoweredOn"
            }
        }
    
    override public func receiveWithCtrl(ctrl : PeripheralViewController) -> Receive {
        return {[unowned self] (msg : Actor.Message) in
            switch (msg) {
                case let m as BLEPeripheral.PeripheralManagerDidUpdateState:
                    ^{ctrl.navigationItem.prompt = "\(self.CBStateToString(state: m.state))"}
                
                case is ToggleAdvertising:
                    let svc = CBMutableService(type: BLEData().svc, primary: true)
                    svc.characteristics = [self.onClickCharacteristic]
                    
                    self.peripheral ! BLEPeripheral.StartAdvertising(sender:self.this, advertisementData:self.advertisementData, svcs:[svc])
                    self.addListener(sender: msg.sender)
                
                case is BLEPeripheral.DidStartAdvertising:
                    self.become(name: self.states.advertising, state: self.advertising(ctrl: ctrl))
                    ^{ctrl.advertisingButton.setTitle("Advertising", for: .normal)}
                
                case is BLEPeripheral.DidStopAdvertising:
                    ^{ctrl.advertisingButton.setTitle("Idle", for: .normal)}
            
                
                default :
                    self.receive(msg: msg)
            }
        }
    }
    
    func advertising(ctrl : PeripheralViewController) -> Receive {
        return {[unowned self] (msg : Actor.Message) in
            switch (msg) {
                
                case is BLEPeripheral.DidAddService:
                    let alert = UIAlertController(title: "did add service", message: nil,                         preferredStyle: .alert)
                    ^{
                        ctrl.present(alert, animated:true,  completion: nil)
                    }
                    self.scheduleOnce(seconds: 1, block: {() in
                        ^{
                            alert.dismiss(animated: true, completion: nil)
                        }
                    })
                
                case is ToggleAdvertising:
                    self.peripheral ! BLEPeripheral.StopAdvertising(sender: self.this)
                    self.unbecome()
                    ^{ctrl.advertisingButton.setTitle("Idle", for: .normal)}
                
                case is OnClick:
                    if let data = NSDate.init().debugDescription.data(using: String.Encoding.utf8) {
                     self.peripheral ! BLEPeripheral.UpdateCharacteristicValue(sender: self.this, char: self.onClickCharacteristic, centrals: nil, value: data)
                    }
                
                case let m as BLEPeripheral.CentralDidSubscribeToCharacteristic:
                    self.become(name: self.states.connected, state: self.connected(ctrl: ctrl, central : m.central))
                    ^{
                        ctrl.statusCell.detailTextLabel!.text = "connected to \(m.central.identifier.uuidString)"
                    }
                
                default :
                    self.receiveWithCtrl(ctrl: ctrl)(msg)
            }
        }
    }
    
    public func connected(ctrl : PeripheralViewController, central : CBCentral) -> Receive {
        return {[unowned self](msg : Actor.Message) in
            switch(msg) {
                case is OnClick :
                    if let data = NSDate.init().debugDescription.data(using: String.Encoding.utf8) {
                        self.peripheral ! BLEPeripheral.UpdateCharacteristicValue(sender: self.this, char: self.onClickCharacteristic, centrals: [central], value: data)
                    }
                
                case let m as BLEPeripheral.DidReceiveWriteRequests:
                    m.requests.forEach { (request) in
                        self.peripheral ! BLEPeripheral.RespondToRequest(sender: self.this, request: request, result: .success)
                    }
                    let alert = UIAlertController(title: "did receive click", message: nil,                         preferredStyle: .alert)
                    ^{
                        ctrl.present(alert, animated:true,  completion: nil)
                    }
                    self.scheduleOnce(seconds: 1, block: {() in
                        ^{
                            alert.dismiss(animated: true, completion: nil)
                        }
                    })
        
                case let m as BLEPeripheral.DidReceiveReadRequest:
                    m.request.value = self.onClickCharacteristic.value
                    self.peripheral ! BLEPeripheral.RespondToRequest(sender: self.this, request: m.request, result: .success)
                
                case is BLEPeripheral.CentralDidUnsubscribeFromCharacteristic:
                    self.unbecome()
                    ^{
                        ctrl.statusCell.detailTextLabel!.text = "disconnected"
                    }
                
                default:
                    self.advertising(ctrl: ctrl)(msg)
            }
        }
    }
}
