//
//  CalendarTableViewCell.swift
//  NPU_Life
//
//  Created by BigAnna on 2021/8/2.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    var mySuperView:CalendarTableViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addToCal(_ sender: UIButton) {
        let myAlert = UIAlertController(title: dateLabel.text, message: eventLabel.text, preferredStyle: .alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        mySuperView?.present(myAlert, animated: true, completion: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
