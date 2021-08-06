//
//  CourseTableViewCell.swift
//  NPU_Life
//
//  Created by BigAnna on 2021/7/25.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

    @IBOutlet var WeekNameCollection: [UILabel]?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
