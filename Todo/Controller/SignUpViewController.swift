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
        func postSignUp(_ parameters:SignUpRequset) {
            AF.request("13.209.10.30:4004/user", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
                .validate()
                .responseDecodable(of: SignUpResponse.self) { [self] response in
                    switch response.result {
                    case .success(let response):
                        if(response.isSuccess == true){
                            print(response.message)
                        }
                        
                        else{
                            print(response.message)
                        }
                        
                    case .failure(let error):
                        print("서버 통신 실패")
                    }
                }
        }
        
    }
    
}
