//
//  TodoDetailViewController.swift
//  Todo
//
//  Created by 김민희 on 2022/02/19.
//

import UIKit

class TodoDetailViewController: UIViewController {

    @IBOutlet weak var detailTitleLabel: UILabel!
    
    @IBOutlet weak var detailDateLabel: UILabel!
    
    @IBOutlet weak var detailContentLabel: UILabel!
    
    var receiveTitle = ""
    var receiveDate = ""
    var receiveContent = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailTitleLabel.text = receiveTitle
        detailDateLabel.text = receiveDate
        detailContentLabel.text = receiveContent
     
    }
    
}
