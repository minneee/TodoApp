//
//  LoginViewController.swift
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
    
    @IBOutlet weak var autoLoginButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(UserDefaults.standard.string(forKey: "auto") == "auto"){
            let storyBoard = UIStoryboard(name: "todo", bundle: nil)
            let VC = storyBoard.instantiateViewController(withIdentifier: "TodoCalendarViewController") as! TodoCalendarViewController
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @IBAction func goSignUpButtonAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let signUpVC = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }

    @IBAction func autoLoginButtonAction(_ sender: UIButton) {
        sender.isSelected.toggle()
  
        if sender.isSelected == true {
            //자동로그인 선택
            UserDefaults.standard.set("auto", forKey: "auto")
        }
        else {
            UserDefaults.standard.removeObject(forKey: "auto")
        }
    }
    
    
    @IBAction func loginButtonAction(_ sender: Any) {
        print("로그인 클릭")
        
        let id = idTextField.text ?? ""
        let pw = pwTextField.text ?? ""
        
        let param = LoginRequest(userid: id, userpw: pw)
        postLogin(param)
    }
    
    
    func postLogin(_ parameters: LoginRequest) {
        AF.request("http://13.209.10.30:4004/user/login", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: LoginResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if(response.isSuccess == true){
                        print("로그인 성공")
                        //성공 로직
                        UserDefaults.standard.set(self.idTextField.text, forKey: "id")
                        print(UserDefaults.standard.string(forKey: "id"))

                        //루트 컨트롤러 변경
                        let storyBD = UIStoryboard(name: "todo", bundle: nil)
                        let VC2 = storyBD.instantiateViewController(identifier: "CalendarTabBar")
                        changeRootViewController(VC2)
                    }
                    
                    else{
                        print("로그인 실패\(response.message)")
                        //alert message
                        let loginFailAlert = UIAlertController(title: "경고", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        
                        let loginFailAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                        loginFailAlert.addAction(loginFailAction)
                        self.present(loginFailAlert, animated: true, completion: nil)
                        
                        UserDefaults.standard.removeObject(forKey: "auto")
                    }
                    
                    
                case .failure(let error):
                    print("서버 통신 실패")
                    let loginFailAlert = UIAlertController(title: "경고", message: "서버 통신에 실패하였습니다.", preferredStyle: UIAlertController.Style.alert)
                    
                    let loginFailAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                    loginFailAlert.addAction(loginFailAction)
                    self.present(loginFailAlert, animated: true, completion: nil)
                    
                    UserDefaults.standard.removeObject(forKey: "auto")
                }
                
            }
    }
    
    func changeRootViewController(_ viewControllerToPresent: UIViewController) {
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = viewControllerToPresent
                UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
            } else {
                viewControllerToPresent.modalPresentationStyle = .overFullScreen
                self.present(viewControllerToPresent, animated: true, completion: nil)
            }
    }
 
}

