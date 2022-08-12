//
//  SettingViewController.swift
//  Todo
//
//  Created by mini on 2022/08/05.
//

import Foundation
import Alamofire

struct SettingList {
    var settingTitle: String
}


class SettingViewController: UIViewController {
    
    @IBOutlet weak var settingTableView: UITableView!
    
    var settingList: [SettingList] = [
        SettingList(settingTitle: "비밀번호 변경"),
        SettingList(settingTitle: "로그아웃"),
        SettingList(settingTitle: "회원 탈퇴")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "설정"
        
        settingTableView.estimatedRowHeight = 50 //cell 최소 높이
        settingTableView.rowHeight = UITableView.automaticDimension //50 이상일 때 동적 높이
        
        self.settingTableView.delegate = self
        self.settingTableView.dataSource = self
        self.settingTableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        
        userCell.cellSettingLabel.text = settingList[indexPath.row].settingTitle
        return userCell
    }
    
}
