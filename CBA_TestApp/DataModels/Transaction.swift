//
//  Transaction.swift
//  CBA_TestApp
//
//  Created by Kiran Gurung on 31/10/17.
//  Copyright © 2017 Kiran Gurung. All rights reserved.
//

import Foundation

class Transaction {
    var id: String
    private var effectiveDate: String
    var desc: String
    var amount: Float
    var atmID: String?
    var isPending: Bool
    
    var formattedDate: String {
        return Transaction.formatDateString(effectiveDate)!
    }
    var formattedDescp: String {
        let descp = isPending ? "Pending: \(desc)": desc
        return descp
    }
    
//    static var transInterval: String? {
//        let passedBy: String?
//        switch calculateDaysPassedBy(transactionDate: formattedDate) {
//        case let days where days == 0:
//            passedBy = "Today"
//        case let days where days == 1:
//            passedBy = "Yesterday"
//        case let days where days > 1:
//            passedBy = "\(days) Days Ago"
//        default:
//            passedBy = nil
//        }
//        return passedBy
//    }
    
    var description:String {
        return "{\(id), \(effectiveDate), \(amount) }"
    }
    
    
    init(id: String, effectiveDate: String, desc: String, amount: Float, amtID: String?, isPending: Bool) {
        self.id = id
        self.desc = desc.replacingOccurrences(of: "<br/>", with: "\n")
        self.amount = amount
        self.atmID = amtID
        self.effectiveDate = effectiveDate
        self.isPending = isPending
    }
    
    private class func formatDateString(_ effectiveDate: String) -> String? {
        var dateFormatter = getDateFormatter("dd/MM/yyyy")
        
        let date = dateFormatter.date(from: effectiveDate)
        
        dateFormatter = getDateFormatter("dd MMM yyyy")
        
        let formattedDate = dateFormatter.string(from: date!)
        
        return formattedDate
    }
    
    private class func getDateFormatter(_ dateFormat: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter
    }
    
    class func calculateDaysPassedBy(transactionDate: String) -> String? {
        let dateFormatter = getDateFormatter("dd MMM yyyy")
        let transactionDate = dateFormatter.date(from: transactionDate)
        let currentDate = dateFormatter.date(from: dateFormatter.string(from: Date()))
        let components = Calendar.current.dateComponents([.day], from: transactionDate!, to: currentDate!)
        print(components.day!)
        let passedBy: String?
        switch components.day! {
        case let days where days == 0:
            passedBy = "Today"
        case let days where days == 1:
            passedBy = "Yesterday"
        case let days where days > 1:
            passedBy = "\(days) Days Ago"
        default:
            passedBy = nil
        }
        return passedBy
    }
}
