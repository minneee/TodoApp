//
//  SettingViewController.swift
//  Todo
//
//  Created by mini on 2022/08/05.
//

import Foundation
import Alamofire

class SettingViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "설정"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
}
