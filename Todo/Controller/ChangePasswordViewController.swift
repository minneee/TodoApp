//
//  ChangePasswordViewController.swift
//  Todo
//
//  Created by 김민희 on 2022/10/14.
//

import UIKit
import Alamofire


class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var newPwTextField: UITextField!
    
    @IBOutlet weak var newPwCheckTextField: UITextField!
    
    @IBOutlet weak var pwChangeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "비밀번호 변경"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    @IBAction func pwChangeButtonAction(_ sender: Any) {
        let uuid = UserDefaults.standard.string(forKey: "id") ?? ""
        let pw = newPwTextField.text ?? ""
        let pwCheck = newPwCheckTextField.text ?? ""
        let param = PwChangeRequset(uuid: uuid, password: pw, checkPassword: pwCheck)
        
        postPwChange(param)
    }
    
    
    func postPwChange(_ parameters: PwChangeRequset) {
        AF.request("http://54.180.25.129:8080/password", method: .put, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: PwChangeResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if(response.success == true){
                        print("비밀번호 변경 성공")
                        //성공 로직
                        let pwChangeAlert = UIAlertController(title: "알림", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let pwChangeAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { ACTION in
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                        pwChangeAlert.addAction(pwChangeAction)
                        self.present(pwChangeAlert, animated: true, completion: nil)
                    }
                    
                    else{
                        print("비밀번호 변경 실패\(response.message)")
                        //alert message
                        let pwChangeFailAlert = UIAlertController(title: "경고", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        let pwChangeFailAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                        
                        pwChangeFailAlert.addAction(pwChangeFailAction)
                        self.present(pwChangeFailAlert, animated: true, completion: nil)
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
}
