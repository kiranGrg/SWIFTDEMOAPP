//
//  FetchTransactionDetail.swift
//  CBA_TestApp
//
//  Created by Kiran Gurung on 31/10/17.
//  Copyright © 2017 Kiran Gurung. All rights reserved.
//

import Foundation

//To hold reource URLs variation can be achieved while working including baseURL and
struct API {
    static let baseURL = "https://www.dropbox.com"
    static let pathURI = "s/tewg9b71x0wrou9/data.json?dl=1"
}


protocol FetchTransactionDelegate{
    func fetchingAndParsingCompleted(withAccount: Account) -> Void
}

public class PrivateFetchHandler {
    
    let baseURL: URL?
    var delegate: FetchTransactionDelegate?
    
    private static let sharedHandler: PrivateFetchHandler = {
        return PrivateFetchHandler()
    }()
    
    private init() {
        if let validURL = URL(string: API.baseURL) {
            self.baseURL = validURL
        }
        else{
            //set default URL incase of failure
            self.baseURL = nil
        }
    }
    
    class func shared() -> PrivateFetchHandler {
        return self.sharedHandler
    }
    
    //fetching from file
    func startFetchingDataFromLocalDirecotry() -> Void {
        if let fileURL = Bundle.main.url(forResource: "exercise", withExtension: "json") {
            if let data = try? Data(contentsOf: fileURL, options: .alwaysMapped) {
                parseDataToJson(data)
            }
        }
        
    }
    
    //fecthing from online
    func startFetchingDataFromAPI(_ pathURI: String) {
        let resourceURL = self.baseURL?.appendingPathComponent(API.pathURI)
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: resourceURL!, completionHandler: {[unowned self] (data, response, error) -> Void in
            guard let err = error else {
                print("Error Accoured")
                return
            }
            guard let receievedData = data else { return }
            
            self.parseDataToJson(receievedData)
            
        }).resume()
    }
    
    
    private func parseDataToJson(_ data: Data) {
        if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : AnyObject] {
            
            //Json data
            guard let json = jsonObj else {
                print("error with json")
                return }
            
            //Account Details
            guard let account = json["account"] as? [String : AnyObject], let name = account["accountName"] as? String, let acc = account["accountNumber"] as? String, let available = account["available"] as? Float, let balance = account["balance"] as? Float else {
                print("error in account formats")
                return }
            
            //Transaction
            guard let trans =  json["transactions"] as? [AnyObject] else {
                print("error in transaction section formats")
                return }
            var transactionsArr = parseTransaction(transactions: trans, isPending: false)
            
            //Pending
            guard let pending = json["pending"] as? [AnyObject] else {
                print("error in pending formats")
                return }
            if let pendingTransArr = parseTransaction(transactions: pending, isPending: true) {
                transactionsArr?.append(contentsOf: pendingTransArr)
            }
            
            guard let atms = json["atms"] as? [AnyObject] else { return }
            let atmsArr = parseAtmsLocations(atmsInfo: atms)
            
            
            let userAccount = Account(accName: name, accNumber: acc, available: available, balance: balance, transactions: transactionsArr, atms: atmsArr)
            self.delegate?.fetchingAndParsingCompleted(withAccount: userAccount)
        }
    }
    
    
    func parseTransaction(transactions: [AnyObject], isPending: Bool) -> [Transaction]? {
        var transArr = [Transaction]()
        for trans in transactions {
            if let trans = trans as? [String : AnyObject] {
                if let id = trans["id"] as? String, let date = trans["effectiveDate"] as? String, let descp = trans["description"] as? String, let amount = trans["amount"] as? Float {
                        transArr.append(Transaction(id: id, effectiveDate: date, desc: descp, amount: amount, amtID: (trans["atmId"] as? String) ?? nil, isPending: isPending))
                    }
                    
                }
            }
        
        return transArr
    }
    
    func  parseAtmsLocations(atmsInfo: [AnyObject]) -> [ATMLocation]? {
        var atmsArr = [ATMLocation]()
        for atms in atmsInfo {
            if let atms = atms as? [String : AnyObject] {
                if let id = atms["id"] as? String, let name = atms["name"] as? String, let addr = atms["address"] as? String, let location = atms["location"] as? [String : Float], let lat = location["lat"] as? Float, let lng = location["lng"] as? Float{
                    
                    atmsArr.append(ATMLocation(id: id, name: name, address: addr, latitude: lat, longitutude: lng))
                }
                
            }
        }
        
        return atmsArr
    }
}

