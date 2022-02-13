//
//  ViewController.swift
//  Todo
//
//  Created by mini on 2022/02/09.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var pwTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var goSignUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonAction(_ sender: Any) {
        print("로그인 클릭")
        
        let storyBoard = UIStoryboard(name: "todo", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "AddTodoViewController") as! AddTodoViewController
        self.navigationController?.pushViewController(VC, animated: true)
        /*
        func postLogin(_ parameters: LoginRequest) {
            AF.request("13.209.10.30:4004/user/login", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
                .validate()
                .responseDecodable(of: LoginResponse.self) { [self] response in
                    switch response.result {
                    case .success(let response):
                        if(response.isSuccess == true){
                            print("로그인 성공")
                        }
                        
                        else{
                            print("로그인 실패\(response.message)")
                            //alert message
                        }
                        
                        
                    case .failure(let error):
                        print("서버 통신 실패")
                    }
                    
                }
        }*/
    }
    
    @IBAction func goSignUpButtonAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let signUpVC = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    
}

