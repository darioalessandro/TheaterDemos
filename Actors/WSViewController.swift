//
//  WSViewController.swift
//  Actors
//
//  Created by Dario Lencina on 9/29/15.
//  Copyright © 2015 dario. All rights reserved.
//

import UIKit
import Theater

class WSRViewController : ViewCtrlActor<WSViewController>, UITableViewDataSource, UITableViewDelegate  {
    
    struct States {
        let connecting = "Connecting"
        let connected = "Connected"
        let disconnected = "Disconnected"
    }
    
    let states = States()
    
    lazy var wsClient : ActorRef = self.actorOf(WebSocketClientWrapper.self, name:"WebSocketClientWrapper")
    
    var receivedMessages : [(String, NSDate)] = [(String, NSDate)]()
    
    // MARK: UITableView related methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.receivedMessages.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndIndexPathPath: IndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("device")!
        let s : (String, NSDate) = self.receivedMessages[indexPath.row]
        cell.textLabel?.text = s.0
        cell.detailTextLabel?.text = s.1.description
        return cell
    }
    
    // MARK: Actor states
    
    override func receiveWithCtrl(ctrl : WSViewController) -> Receive {
        ^{
            ctrl.tableView.dataSource = self
            ctrl.tableView.delegate = self
        }
        return {[unowned self] (msg : Actor.Message) in
            switch(msg) {
            case is WebSocketClientWrapper.Connect:
                self.become(name:  self.states.disconnected, state: self.disconnected(ctrl))
                self.this ! msg
                
            default:
                ctrl.tableView.dataSource = nil
                ctrl.tableView.delegate = nil
                self.receive(msg: msg)
            }
        }
    }
    
    func disconnected(ctrl : WSViewController) -> Receive {
        return {[unowned self] (msg : Actor.Message) in
            switch(msg) {
            case let w as WebSocketClientWrapper.Connect:
                self.become(name: self.states.connecting, state: self.connecting(ctrl: ctrl, url:w.url))
                self.WebSocketClientWrapper.Connect(url: w.url, sender: self.this)
                ^{ ctrl.title = "Connecting"}
                
            case let m as WebSocketClientWrapper.OnDisconnect:
                ^{ctrl.title = "Disconnected"
                 ctrl.navigationItem.prompt = m.error?.localizedDescription}
                
            default:
                self.receive(msg: msg)
            }
        }
    }
    
    func connecting(ctrl : WSViewController, url : NSURL) -> Receive {
        return {[unowned self] (msg : Actor.Message) in
            switch(msg) {
                
            case is WebSocketClientWrapper.OnConnect:
                ^{ctrl.title = "Connected"
                  ctrl.navigationItem.prompt = nil
                  ctrl.textField.becomeFirstResponder()}
                self.become(name: self.states.connected, state:self.connected(ctrl: ctrl, url: url))
                
            case let m as WebSocketClientWrapper.OnDisconnect:
                self.unbecome()
                self.this ! m

                self.scheduleOnce(seconds: 1,block: {
                    self.this ! WebSocketClientWrapper.Connect(url: url, sender: self.this)
                })
            
            default:
                self.receive(msg: msg)
            }
        
        }
    }
    
    func connected(ctrl : WSViewController, url : NSURL) -> Receive {
        
        return {[unowned self](msg : Actor.Message) in
            switch(msg) {
                case let w as WebSocketClientWrapper.SendMessage:
                    self.receivedMessages.append(("You: \(w.message)", NSDate.init()))
                    let i = self.receivedMessages.count - 1
                    ^{
                      let lastRow = IndexPath.init(forRow: i, inSection: 0)
                      ctrl.tableView.insertRowsAtIndexPaths([lastRow], withRowAnimation: UITableViewRowAnimation.Automatic)
                      ctrl.tableView.scrollToRowAtIndexPath(lastRow, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)}
                    self.wsClient ! WebSocketClient.SendMessage(sender: self.this, message: w.message)
                
                case let w as WebSocketClientWrapper.OnMessage:
                    self.receivedMessages.append(("Server: \(w.message)", NSDate.init()))
                    let i = self.receivedMessages.count - 1
                    ^{
                      let lastRow = IndexPath.init(forRow: i, inSection: 0)
                      ctrl.tableView.insertRowsAtIndexPaths([lastRow], withRowAnimation: UITableViewRowAnimation.Automatic)
                      ctrl.tableView.scrollToRowAtIndexPath(lastRow, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)}
                    
                case let m as WebSocketClientWrapper.OnDisconnect:
                    self.popToState(self.states.disconnected)
                    self.this ! m
                    self.scheduleOnce(1,block: {
                        self.this ! WebSocketClient.Connect(url: url, sender: self.this)
                    })
                    
                default:
                    self.receive(msg)
            }
        }
    }

    required init(context: ActorSystem, ref: ActorRef) {
        super.init(context: context, ref: ref)
    }
    
    /**
    Cleanup resources, in this case, destroy the wsClient ActorRef
    */
    
    deinit {
        self.wsClient ! Harakiri(sender: nil)
    }
}

class WSViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendbar: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var send: UIButton!
    @IBOutlet weak var bottomTextField: NSLayoutConstraint!
    
    lazy var system : ActorSystem = ActorSystem(name:"WS")
    
    lazy var wsCtrl : ActorRef = self.system.actorOf(clz: WSRViewController.self, name:  "WSRViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wsCtrl ! SetViewCtrl(ctrl: self)
        wsCtrl ! WebSocketClientWrapper.Connect(url: NSURL(string: "wss://echo.websocket.org")!, sender : nil)
        self.addNotifications()
        send.addTarget(self, action: #selector(WSViewController.onClick(_:)), for: .TouchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.isBeingDismissed || self.isMovingFromParentViewController {
            system.stop()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addNotifications() {
        NotificationCenter.defaultCenter.addObserver(self, selector:#selector(WSViewController.keyboardWillAppear(notification:)), name: UIKeyboardWillShowNotification, object: nil)
        NotificationCenter.defaultCenter.addObserver(self, selector:#selector(WSViewController.keyboardWillDisappear(notification:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        wsCtrl ! WebSocketClientWrapper.SendMessage(sender: nil, message: textField.text!)
        return true
    }
    
    @objc func onClick(btn : UIButton) {
        wsCtrl ! WebSocketClientWrapper.SendMessage(sender: nil, message: textField.text!)
    }
    
    public func keyboardWillAppear(notification: NSNotification){
        let userInfo:Dictionary = notification.userInfo!
        let keyboardSize:CGSize = (userInfo.objectForKey(UIKeyboardFrameBeginUserInfoKey)! as AnyObject).cgRectValue.size
        
        bottomTextField.constant = keyboardSize.height;
        self.view.setNeedsUpdateConstraints()
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillDisappear(notification: NSNotification){
        bottomTextField.constant = 0;
        self.view.setNeedsUpdateConstraints()
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    
}