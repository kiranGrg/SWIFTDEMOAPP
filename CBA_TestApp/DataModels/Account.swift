//
//  Account.swift
//  CBA_TestApp
//
//  Created by Kiran Gurung on 31/10/17.
//  Copyright © 2017 Kiran Gurung. All rights reserved.
//

import Foundation

class Account {
    var accName:String
    var accNumber: String
    var available: Float
    var balance: Float
    
    var atms: [ATMLocation]?
    private var transactions: [Transaction]?
    var groupedBasedOnDate: [String: [Transaction]] {
        
        let groupedTransaction = Dictionary(grouping: transactions!) {
            (transaction: Transaction) in return transaction.formattedDate
        }
        
        return groupedTransaction
    }
    
    var transByDateKeys: [String]? {
        return groupedBasedOnDate.flatMap({ (key, value) -> String? in
            return key
        }).sorted(by: { (s1, s2) -> Bool in
            return s1 > s2
        })
    }
    
    var description: String {
        return "{\(accName), \(accNumber)}"
    }
    
    init(accName: String, accNumber: String, available: Float, balance: Float, transactions: [Transaction]?, atms: [ATMLocation]?) {
        self.accName = accName
        self.accNumber = accNumber
        self.available = available
        self.balance = balance
        self.transactions = transactions
        self.atms = atms
    }
    
    convenience init () {
        self.init(accName: "", accNumber: "", available: 0, balance: 0, transactions: nil, atms: nil)
    }
    
    
}
