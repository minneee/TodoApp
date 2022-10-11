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
    
    var pwCheck = false
    
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
    
   
    
    
    //setting에서 항목을 클릭 했을 때 실행되는 함수
    func settingContent(_ rowIndex: Int) {
        switch rowIndex {
        case 1:
            print("1") //비밀번호 변경
            
            
            
        case 2:
            print("2") //로그아웃
  
            let logoutAlert = UIAlertController(title: "알림", message: "로그아웃 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
            
            let logoutFalseAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: nil)
            let logoutTrueAction = UIAlertAction(title: "로그아웃", style: UIAlertAction.Style.destructive) { ACTION in
                //자동로그인 해제
                UserDefaults.standard.set(false, forKey: "auto")
                UserDefaults.standard.removeObject(forKey: "id")
                
                //루트 컨트롤러 변경
                let storyBD = UIStoryboard(name: "Main", bundle: nil)
                let VC2 = storyBD.instantiateViewController(identifier: "NavController")
                self.changeRootViewController(VC2)
            }
            
            logoutAlert.addAction(logoutFalseAction)
            logoutAlert.addAction(logoutTrueAction)
            self.present(logoutAlert, animated: true, completion: nil)
        
                
        case 3:
            print("3") //회원 탈퇴
              
            var pwCheckAlert = UIAlertController(title: "회원 탈퇴", message: "현재 비밀번호를 입력하세요", preferredStyle: UIAlertController.Style.alert)
            
            let pwCheckFalseAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: nil)
            let pwCheckTrueAction = UIAlertAction(title: "비밀번호 확인", style: UIAlertAction.Style.destructive) { ACTION in
                //확인 버튼 (비밀번호 확인 API -> 탈퇴 확인 알림)
                let uuid = UserDefaults.standard.string(forKey: "id") ?? ""
                let password = pwCheckAlert.textFields?[0].text ?? ""
    
                let param = OriginPwCheckRequest(uuid: uuid, password: password)
                self.postOriginPwCheck(param)
                
                if self.pwCheck == true {
                    //탈퇴 알림
                    let withdrawAlert = UIAlertController(title: "알림", message: "탈퇴하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
                    
                    let withdrawFalseAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: nil)
                    let withdrawTrueAction = UIAlertAction(title: "회원 탈퇴", style: UIAlertAction.Style.destructive) { ACTION in
                        //회원 탈퇴 API호출
                        let uuid = UserDefaults.standard.string(forKey: "id") ?? ""
                        print(uuid)
                        
                        let param = WithdrawRequest(uuid: uuid)
                        self.postWithdraw(param)
                    }
                    
                    withdrawAlert.addAction(withdrawFalseAction)
                    withdrawAlert.addAction(withdrawTrueAction)
                    self.present(withdrawAlert, animated: true, completion: nil)
                    
                    
                }
                
            }
            
            self.pwCheck = false
            
            pwCheckAlert.addAction(pwCheckFalseAction)
            pwCheckAlert.addAction(pwCheckTrueAction)
            pwCheckAlert.addTextField()
            self.present(pwCheckAlert, animated: true, completion: nil)
            
            
            
            
            
            
            
            
        default:
            print("오류입니닷")
        }
    }
    
    //루트 컨트롤러 변경
    func changeRootViewController(_ viewControllerToPresent: UIViewController) {
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = viewControllerToPresent
                UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
            } else {
                viewControllerToPresent.modalPresentationStyle = .overFullScreen
                self.present(viewControllerToPresent, animated: true, completion: nil)
            }
    }
    
    
    func postWithdraw(_ parameters: WithdrawRequest) {
        AF.request("http://54.180.25.129:8080/withdraw", method: .delete, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: WithdrawResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if(response.success == true){
                        print("회원 탈퇴 성공")
                        //성공 로직
                        
                        //자동로그인 해제
                        UserDefaults.standard.set(false, forKey: "auto")
                        UserDefaults.standard.removeObject(forKey: "id")
                        
                        //루트 컨트롤러 변경
                        let storyBD = UIStoryboard(name: "Main", bundle: nil)
                        let VC2 = storyBD.instantiateViewController(identifier: "NavController")
                        self.changeRootViewController(VC2)
                    }
                    
                    else{
                        print("회원 탈퇴 실패\(response.message)")
                        //alert message
                        let postWithdrawFailAlert = UIAlertController(title: "경고", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        
                        let postWithdrawFailAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                        postWithdrawFailAlert.addAction(postWithdrawFailAction)
                        self.present(postWithdrawFailAlert, animated: true, completion: nil)
                    }
                    
                    
                case .failure(let error):
                    print(error)
                    print("서버 통신 실패")
                    let postWithdrawFailAlert = UIAlertController(title: "경고", message: "서버 통신에 실패하였습니다.", preferredStyle: UIAlertController.Style.alert)
                    
                    let postWithdrawFailAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                    postWithdrawFailAlert.addAction(postWithdrawFailAction)
                    self.present(postWithdrawFailAlert, animated: true, completion: nil)
                }
                
            }
    }
    
    
    func postOriginPwCheck(_ parameters: OriginPwCheckRequest) {
        AF.request("http://54.180.25.129:8080/password/origin", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: OriginPwCheckResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if(response.success == true){
                        print("비밀번호 확인 성공")
                        //성공 로직
                        pwCheck = true
                        
                    }
                    
                    else{
                        print("비밀번호 확인 실패\(response.message)")
                        //alert message
                        let postOriginPwCheckFailAlert = UIAlertController(title: "경고", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        
                        let postOriginPwCheckFailAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                        postOriginPwCheckFailAlert.addAction(postOriginPwCheckFailAction)
                        self.present(postOriginPwCheckFailAlert, animated: true, completion: nil)
                    }
                    
                    
                case .failure(let error):
                    print(error)
                    print("서버 통신 실패")
                    let postOriginPwCheckFailAlert = UIAlertController(title: "경고", message: "서버 통신에 실패하였습니다.", preferredStyle: UIAlertController.Style.alert)
                    
                    let postOriginPwCheckFailAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                    postOriginPwCheckFailAlert.addAction(postOriginPwCheckFailAction)
                    self.present(postOriginPwCheckFailAlert, animated: true, completion: nil)
                }
                
            }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = indexPath.row + 1
        print(selectedIndex)
        
        settingContent(selectedIndex)
    }
    
}

