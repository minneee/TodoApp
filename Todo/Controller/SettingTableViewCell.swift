//
//  SettingTableViewCell.swift
//  Todo
//
//  Created by mini on 2022/08/08.
//

import UIKit


class SettingTableViewCell: UITableViewCell {


    @IBOutlet weak var cellSettingLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
