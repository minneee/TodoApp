//
//  SignUpViewController.swift
//  Todo
//
//  Created by mini on 2022/02/09.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var pwTextField: UITextField!
    
    @IBOutlet weak var pwCheckTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        print("회원가입 버튼 클릭")
        
        let name = nameTextField.text ?? ""
        let id = idTextField.text ?? ""
        let pw = pwTextField.text ?? ""
        let pwCheck = pwCheckTextField.text ?? ""
        
        let param = SignUpRequest(username: name, userid: id, userpw: pw, userpw_check: pwCheck)
        postSignUp(param)
    }
    
    
    func postSignUp(_ parameters:SignUpRequest) {
        AF.request("http://13.209.10.30:4004/user", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: SignUpResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if(response.isSuccess == true){
                        print(response.message)
                        //성공 로직
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    else{
                        print(response.message)
                        //실패 알림
                        let signUpFailAlert = UIAlertController(title: "경고", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        
                        let signUpFailAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                        signUpFailAlert.addAction(signUpFailAction)
                        self.present(signUpFailAlert, animated: true, completion: nil)
                    }
                    
                case .failure(let error):
                    print("서버 통신 실패")
                    let signUpFailAlert = UIAlertController(title: "경고", message: "서버 통신에 실패하였습니다.", preferredStyle: UIAlertController.Style.alert)
                    
                    let signUpFailAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                    signUpFailAlert.addAction(signUpFailAction)
                    self.present(signUpFailAlert, animated: true, completion: nil)
                
                    
                
                }
            }
    }
    
    
}
