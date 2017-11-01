//
//  AccountDetailsView.swift
//  CBA_TestApp
//
//  Created by Kiran Gurung on 31/10/17.
//  Copyright © 2017 Kiran Gurung. All rights reserved.
//

import UIKit

class AccountDetailsView: UITableViewController {
    
    var account: Account = Account()
    var atmLocation: ATMLocation = ATMLocation()

    @IBOutlet weak var lblAccName: UILabel!
    @IBOutlet weak var accAccNum: UILabel!
    @IBOutlet weak var lblAvilableFund: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionHeaderHeight = 35
        tableView.separatorColor = UIColor.clear
        
        PrivateFetchHandler.shared().delegate = self
        PrivateFetchHandler.shared().startFetchingDataFromLocalDirecotry()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "showMap" {
            print("good to go")
            let mapViewController = segue.destination as! MapViewController
            mapViewController.atmLocation = self.atmLocation
        }
    }
    

}

//To implement the tableviewdelegates and datasource functions
extension AccountDetailsView {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if let count = self.account.transByDateKeys?.count
        {
            return count
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let key = self.account.transByDateKeys?[section]
        if let sectionItemArr = self.account.groupedBasedOnDate[key!]{
            return sectionItemArr.count
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        let key = self.account.transByDateKeys?[indexPath.section]
        let trans: Transaction = self.account.groupedBasedOnDate[key!]![indexPath.row]
        
        
        if let _ = trans.atmID {
            let cell = tableView.dequeueReusableCell(withIdentifier: "withATMCell", for: indexPath) as! WithAtmLocationTableViewCell
            cell.configureCell(transcation: trans)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "normalCell", for: indexPath) as! NormalTableViewCell
            cell.configureCell(transaction: trans)
            return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderTableViewCell
        let dateString = self.account.transByDateKeys![section]
        let passedByString = Transaction.calculateDaysPassedBy(transactionDate: dateString)!
        headerView.lblDate.text = dateString
        headerView.lblPassedBy.text = passedByString
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell is WithAtmLocationTableViewCell {
                let key = self.account.transByDateKeys![indexPath.section]
                let transactionArr = self.account.groupedBasedOnDate[key]!
                let transaction = transactionArr[indexPath.row]
                let atmId = transaction.atmID!
                let atm = self.account.atms?.filter({ (atm) -> Bool in
                    return atm.id == atmId
                })[0]
                
                self.atmLocation = atm!
                self.performSegue(withIdentifier: "showMap", sender: nil)
            }
            
        }
        else {
            
        }
    }
}


//delegate function implemenation of fechconroller
extension AccountDetailsView: FetchTransactionDelegate {
    
    func fetchingAndParsingCompleted(withAccount: Account) {
        self.account = withAccount
        print("here")
        self.tableView.reloadData()
    }
}
