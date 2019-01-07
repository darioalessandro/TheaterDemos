//
//  BLEActors.swift
//  Actors
//
//  Created by Dario Lencina on 9/29/15.
//  Copyright © 2015 dario. All rights reserved.
//

import Foundation
import UIKit
import Theater
import CoreBluetooth
import AudioToolbox

public class BLEControllersActor : Actor, UITableViewDataSource, UITableViewDelegate, CBPeripheralDelegate {
    
    public struct States {
        let connected = "connected"
    }
    
    let states = States()
    
    var char : CBCharacteristic?
    var devices : BLECentral.PeripheralObservations = BLECentral.PeripheralObservations()
    var identifiers : [String] = [String]()
    weak var ctrl : Optional<UITableViewController> = nil
    weak var deviceViewCtrl : Optional<DeviceViewController> = nil
    weak var observationsCtrl : Optional<UITableViewController> = nil
    var selectedIdentifier : Optional<String> = nil
    lazy var central : ActorRef = self.actorOf(clz: BLECentral.self, name:"BLECentral")
    
    required public init(context : ActorSystem, ref : ActorRef) {
        super.init(context: context, ref: ref)
        self.central ! BLECentral.AddListener(sender: this)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let deviceViewCtrl = self.deviceViewCtrl {
            if tableView.isEqual(deviceViewCtrl.tableView) {
                return deviceViewCtrl.tableView(tableView, numberOfRowsInSection:section)
            }
        }
        
        if let obsCtrl = self.observationsCtrl,
            let selectedId = self.selectedIdentifier,
            let observations = self.devices[selectedId] {
                
                if tableView.isEqual(obsCtrl.tableView) {
                    return observations.count
                }
        }
        return self.identifiers.count
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let deviceViewCtrl = self.deviceViewCtrl {
            if tableView.isEqual(deviceViewCtrl.tableView) {
                return
            }
        }
        
        if let obsCtrl = self.observationsCtrl,
            let _ = self.selectedIdentifier {
                if tableView.isEqual(obsCtrl.tableView) {
                    return
                }
        }
        
        self.selectedIdentifier = identifiers[indexPath.row]
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let deviceViewCtrl = self.deviceViewCtrl {
            if tableView.isEqual(deviceViewCtrl.tableView) {
                 return deviceViewCtrl.tableView(tableView, cellForRowAt: indexPath)
            }
        }
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "device")!
        
        if let obsCtrl = self.observationsCtrl, let selectedId = self.selectedIdentifier, let observations = self.devices[selectedId] {
            if tableView.isEqual(obsCtrl.tableView) {
                let blePeripheral = observations[indexPath.row]
                cell.textLabel?.text = "\(blePeripheral.timestamp) : \(blePeripheral.RSSI)"
                cell.detailTextLabel?.text = blePeripheral.advertisementData.debugDescription
            } else {
                let identifier = self.identifiers[indexPath.row]
                cell.textLabel?.text = self.identifiers[indexPath.row]
                cell.detailTextLabel?.text = "observations = \(self.devices[identifier]?.count ?? 0)"
            }
        } else {
            let identifier = self.identifiers[indexPath.row]
            cell.textLabel?.text = self.identifiers[indexPath.row]
            cell.detailTextLabel?.text = "observations = \(String(describing: self.devices[identifier]?.count))"
        }
        return cell
    }
    
    func connected(peripheral : CBPeripheral) -> Receive {
        return {[unowned self](msg : Actor.Message) in
            switch(msg) {
                
                case is PeripheralActor.OnClick:
                    
                    if let data = NSDate.init().debugDescription.data(using: String.Encoding.utf8), let char = self.char {
                        peripheral.writeValue(data, for: char, type: .withResponse)
                    }
                
            case let m as BLEPeripheralConnection.DidWriteValueForCharacteristic:
                
                if let ctrl : UIViewController = self.deviceViewCtrl {
                    let deviceName = peripheral.name ?? "no name"
                    let alert = UIAlertController(title: "did write to \(deviceName), error: \(m.error.debugDescription)", message: nil, preferredStyle: .alert)
                    ^{
                        ctrl.present(alert, animated:true,  completion: nil)
                    }
                    self.scheduleOnce(seconds: 2, block: {() in
                        ^{
                            alert.dismiss(animated: true, completion: nil)
                        }
                    })
                }

                
                case let m as BLEPeripheralConnection.DidDiscoverServices:
                    if let ctrl : UIViewController = self.deviceViewCtrl {
                        ^{
                            var errorMsg : String? = nil
                            if let error = m.error {
                                errorMsg = error.localizedDescription
                            } else {
                                errorMsg = "did discover service"
                            }
                            let alert = UIAlertController(title: errorMsg, message: nil, preferredStyle: .alert)

                            ctrl.present(alert, animated:true,  completion: nil)
                            self.scheduleOnce(seconds: 1, block: {() in
                                ^{
                                    alert.dismiss(animated: true, completion: nil)
                                }
                            })
                        }
                    }
                    
                case let m as BLEPeripheralConnection.DidDiscoverNoServices:
                    if let error = m.error,
                        let ctrl : UIViewController = self.deviceViewCtrl {
                            ^{
                                ctrl.navigationItem.prompt = "error \(error)"
                            }
                    }
                
                case let m as BLEPeripheralConnection.DidUpdateNotificationStateForCharacteristic:
                    if let error = m.error,
                        let ctrl : UIViewController = self.deviceViewCtrl {
                        let alert = UIAlertController(title: "error \(error)", message: nil,                         preferredStyle: .alert)
                            ^{
                                ctrl.present(alert, animated:true,  completion: nil)
                            }
                        self.scheduleOnce(seconds: 2, block: {() in
                                ^{
                                    alert.dismiss(animated: true, completion: nil)
                                }
                            })
                }
                
   
                case is BLEPeripheralConnection.DidUpdateValueForCharacteristic:
                     AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    if let ctrl : UIViewController = self.deviceViewCtrl {
                        let alert = UIAlertController(title: "onClick \(peripheral.name ?? "no name")", message: nil,                         preferredStyle: .alert)
                        ^{
                            ctrl.present(alert, animated:true,  completion: nil)
                        }
                        self.scheduleOnce(seconds: 2, block: {() in
                            ^{
                                alert.dismiss(animated: true, completion: nil)
                            }
                        })
                    }
                
                case let m as BLEPeripheralConnection.DidDiscoverCharacteristicsForService:
                    if let error = m.error,
                        let ctrl : UIViewController = self.deviceViewCtrl {
                        ^{
                            ctrl.navigationItem.prompt = "error \(error.localizedDescription)"
                        }
                            //self.central ! Peripheral.Disconnect(m.peripheral, sender:self.this)
                    }
                    let chars = m.service.characteristics!.filter({ (char) -> Bool in
                        return char.uuid == BLEData().characteristic
                    })
                
                    if let char : CBCharacteristic = chars.first {
                        self.char = char
                        peripheral.setNotifyValue(true, for: char)
                    }
                
                case let m as BLECentral.Peripheral.OnConnect:
                    if let d = self.deviceViewCtrl {
                        ^{d.stateRow.detailTextLabel?.text = "Connected"}
                    }
                    m.peripheralConnection! ! BLEPeripheralConnection.AddListener(sender : self.this)
                    m.peripheralConnection! ! BLEPeripheralConnection.DiscoverServices(sender: self.this, services: [BLEData().svc])
                
                
                case is RemoveDeviceViewController:
                    ^{ () in
                        self.deviceViewCtrl?.tableView.delegate = nil
                        self.deviceViewCtrl?.tableView.dataSource = nil
                        self.deviceViewCtrl = nil
                    }
                    self.unbecome()                    
                    self.central ! BLECentral.Peripheral.Disconnect(sender : self.this, peripheral : peripheral)
                    
                case let m as BLECentral.Peripheral.OnDisconnect:
                    if let d = self.deviceViewCtrl {
                        ^{d.navigationItem.prompt = "error \(m.error?.localizedDescription ?? "no description")"
                          d.stateRow.detailTextLabel?.text = "Disconnected"}
                        self.scheduleOnce(seconds: 1,block: { () in
                           self.central ! BLECentral.Peripheral.Connect(sender: self.this, peripheral : m.peripheral)
                        })
                    }
                
                default:
                    print("ignoring")
            }
        }
    }
    
    override public func receive(msg: Actor.Message) {
        switch(msg) {
            
        case let m as BLECentral.StartScanning:
            self.central ! BLECentral.StartScanning(services: m.services, sender: self.this)
            
        case is BLECentral.StopScanning:
            self.central ! BLECentral.StopScanning(sender: this)
            
        case let w as SetObservationsController:
            ^{ () in
                self.observationsCtrl = w.ctrl
                self.observationsCtrl?.tableView.delegate = self
                self.observationsCtrl?.tableView.dataSource = self
                self.observationsCtrl?.title = self.selectedIdentifier
                self.observationsCtrl?.tableView.reloadData()
            }

        case is RemoveObservationController:
            ^{ () in
                self.observationsCtrl?.tableView.delegate = nil
                self.observationsCtrl?.tableView.dataSource = nil
                self.observationsCtrl = nil
                self.selectedIdentifier = nil
            }
            
        case let w as SetDeviceListController:
            ^{ () in
                self.ctrl = w.ctrl
                self.ctrl?.tableView.delegate = self
                self.ctrl?.tableView.dataSource = self
                self.ctrl?.tableView.reloadData()
            }
            
        case let w as SetDeviceViewController:
            ^{ () in
                self.deviceViewCtrl = w.ctrl
                self.deviceViewCtrl?.tableView.delegate = self
                self.deviceViewCtrl?.tableView.dataSource = self
                self.deviceViewCtrl?.tableView.reloadData()
            }
            
            if let selected = self.selectedIdentifier,
                let peripherals = self.devices[selected],
                let peripheral = peripherals.first {
                    self.central ! BLECentral.Peripheral.Connect(sender: self.this, peripheral: peripheral.peripheral)
            }
            
        case let m as BLECentral.Peripheral.OnConnect:
            if let d = self.deviceViewCtrl {
                ^{
                    d.stateRow.detailTextLabel?.text = "Connected"
                }
            }
            self.become(name: self.states.connected, state: self.connected(peripheral: m.peripheral))
            self.this ! m
            
        case let observation as BLECentral.DevicesObservationUpdate:
            self.devices = observation.devices
            self.identifiers = Array(self.devices.keys)
            let sections = NSIndexSet(index: 0)
            ^{ () in
                self.ctrl?.tableView.reloadSections(sections as IndexSet, with: .none)
                if let obsCtrl = self.observationsCtrl, let _ = self.selectedIdentifier {
                    obsCtrl.tableView.reloadSections(sections as IndexSet, with: .none)
                }
            }
            
        case is Harakiri:
            central ! Harakiri(sender: this)
            super.receive(msg: msg)
            
        default:
            super.receive(msg: msg)
        }
    }
    
}
