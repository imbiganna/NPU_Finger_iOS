//
//  CourseTableViewCell.swift
//  NPU_Life
//
//  Created by BigAnna on 2021/7/25.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

    @IBOutlet var WeekNameCollection: [UILabel]?
    @IBOutlet weak var shareButton: UIButton!
    
    var superVC:CourseTableTableViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func shareTable(_ sender: UIButton) {
        let shareName = "分享課表"
        shareButton.setTitle("", for: .normal)
        superVC?.superUIView?.shareCourse()
        shareButton.setTitle(shareName, for: .normal)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
