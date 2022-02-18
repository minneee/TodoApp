//
//  TodoTableViewCell.swift
//  Todo
//
//  Created by 김민희 on 2022/02/14.
//

import UIKit

class TodoTableViewCell: UITableViewCell {

    @IBOutlet weak var cellTitleLabel: UILabel!
    
    @IBOutlet weak var cellTimeLabel: UILabel!
    
    @IBOutlet weak var cellContentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
