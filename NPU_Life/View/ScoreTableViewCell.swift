//
//  ScoreTableViewCell.swift
//  NPU_Life
//
//  Created by BigAnna on 2021/7/24.
//

import UIKit

class ScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var midScore: UILabel!
    @IBOutlet weak var finalScore: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
