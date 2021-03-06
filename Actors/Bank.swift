//
//  Bank.swift
//  Actors
//
//  Created by Dario on 10/6/15.
//  Copyright © 2015 dario. All rights reserved.
//

import Foundation
import Theater

public class Bank : ViewCtrlActor<AccountsViewController> {
    
    
    /**
     Subclasses must override this constructor.
     */
    
    required public init(context : ActorSystem, ref : ActorRef) {
        super.init(context: context, ref: ref)
    }
    
    lazy var accountA : ActorRef = self.actorOf(clz: Account.self, name: "AccountA")
    lazy var accountB : ActorRef = self.actorOf(clz: Account.self, name: "AccountB")
    
    var accountALabel : Optional<UILabel> = nil
    var accountBLabel : Optional<UILabel> = nil
    
    public var transfers : [String:(Transfer, Optional<TransferResult>)] = [String : (Transfer, Optional<TransferResult>)]()
    
    @objc func onClickBtoA(click: UIButton) {
        this ! Transfer(origin: accountB, destination: accountA, sender: this, ammount: 1)
    }
    
    @objc func onClickAtoB(click: UIButton) {
        this ! Transfer(origin: accountA, destination: accountB, sender: this, ammount: 1)
    }
    
    public override func receiveWithCtrl(ctrl : AccountsViewController) -> Receive {
        
        ^{
            ctrl.bToA.addTarget(self, action: #selector(Bank.onClickBtoA(click:)), for: .touchUpInside)
            ctrl.aToB.addTarget(self, action: #selector(Bank.onClickAtoB(click:)), for: .touchUpInside)
            self.accountALabel = ctrl.accountABalance
            self.accountBLabel = ctrl.accountBBalance
        }
        
        accountA ! SetAccountNumber(accountNumber: "AccountA", operationId: UUID())
        accountB ! SetAccountNumber(accountNumber: "AccountB", operationId: UUID())
        
        print("accountA \(accountA.path.asString)")
        print("accountB \(accountB.path.asString)")
        
        accountA ! Deposit(sender: this, ammount: 10, operationId: UUID())
        accountB ! Deposit(sender: this, ammount: 10, operationId: UUID())
        
        
        return {[unowned self](msg : Actor.Message) in
            
        switch(msg) {
            case let w as Transfer:
                if self.transfers.keys.contains(w.operationId.uuidString) == false {
                    self.transfers[w.operationId.uuidString] = (w,nil)
                    let wireTransfer = self.actorOf(clz: WireTransferWorker.self, name:"WorkerId\(w.operationId.uuidString)") //TODO: We need to add timeout
                wireTransfer ! w
            }
            
            case let w as TransferResult:
                let uuid = w.operationId.uuidString
            if let transfer = self.transfers[uuid] {
                self.transfers[uuid] = (transfer.0, w)
            }
            
            if w.result.isFailure() { ^{
                    let v = self.transfers[uuid]!
                    UIAlertView(title: "Transaction error from:\(v.0.origin.path.asString) to:\(v.0.destination.path.asString)", message: "\(w.result.description)", delegate: nil, cancelButtonTitle: "ok").show()
                }
            }
            
            self.stop(actorRef: w.sender!)
            
            case let w as OnBalanceChanged:
            ^{
                if let account : ActorRef = w.sender {
                    print("account.path.asString \(account.path.asString)" )
                    switch (account.path.asString) {
                    case self.accountA.path.asString:
                        self.accountALabel?.text = w.balance.description
                        break
                    case self.accountB.path.asString:
                        self.accountBLabel?.text = w.balance.description
                        break
                    default:
                        print("account not found \(account.path.asString)")
                        
                    }
                }
                
            }
            
        default:
            self.receive(msg: msg)
        }
        }
    }
}
