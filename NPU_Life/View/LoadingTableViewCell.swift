//
//  LoadingTableViewCell.swift
//  NPU_Life
//
//  Created by BigAnna on 2021/7/27.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
