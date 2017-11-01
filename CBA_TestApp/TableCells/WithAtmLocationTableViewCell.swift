//
//  WithAtmLocationTableViewCell.swift
//  CBA_TestApp
//
//  Created by Kiran Gurung on 31/10/17.
//  Copyright © 2017 Kiran Gurung. All rights reserved.
//

import UIKit

class WithAtmLocationTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(transcation: Transaction) {
        self.lblDesc.text = transcation.formattedDescp
        self.lblAmount.text = String(transcation.amount)
    }

}
