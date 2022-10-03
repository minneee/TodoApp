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
    
    @IBOutlet weak var idCheckButton: UIButton!
    
    @IBOutlet weak var pwTextField: UITextField!
    
    @IBOutlet var pwCheckListLabel: UILabel!
    
    @IBOutlet weak var pwCheckTextField: UITextField!
    
    @IBOutlet weak var pwCheckLabel: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    //pwCheckTextField 변경 될 때 실행 로직
    @objc func pwCheckTextFieldDidChange(_ sender: Any) {
        if pwTextField.text == pwCheckTextField.text {
            //비밀번호 일치
            pwCheckLabel.text = "비밀번호가 일치합니다"
            pwCheckLabel.textColor = .gray
        }
        else {
            //비밀번호 불일치
            pwCheckLabel.text = "비밀번호가 일치하지 않습니다"
            pwCheckLabel.textColor = .red
        }
    }
    
    //idTextField 변경 될 때 실행 로직
    @objc func idTextFieldDidChange(_ sender: Any) {
        idCheckButton.setTitle("아이디 중복 확인하기", for: .normal)
        idCheckButton.setTitleColor(.red, for: .normal)
        
        signUpButton.isEnabled = false
    }
    
    //pwTextField 변경 될 때 실행 로직
    @objc func pwTextFieldDidChange(_ sender: Any) {
        pwCheckTextField.text = ""
        //제약조건 검사 API호출
        let pw = pwTextField.text
        let param = PwCheckRequest(userPW: pw ?? "")
        postPwCheck(param)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "회원가입"
        
        self.signUpButton.isEnabled = false
        
        //pwCheckTextField가 변경됨을 감지하고 함수를 실행
        self.pwCheckTextField.addTarget(self, action: #selector(self.pwCheckTextFieldDidChange(_:)), for: .editingChanged)
        
        //idTextField가 변경됨을 감지하고 함수를 실행
        self.idTextField.addTarget(self, action: #selector(self.idTextFieldDidChange(_:)), for: .editingChanged)
        
        //pwTextField가 변경됨을 감지하고 함수를 실행
        self.pwTextField.addTarget(self, action: #selector(self.pwTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        print("회원가입 버튼 클릭")
        
        let name = nameTextField.text ?? ""
        let id = idTextField.text ?? ""
        let pw = pwTextField.text ?? ""
        let pwCheck = pwCheckTextField.text ?? ""
        
        let param = SignUpRequest(userNM: name, userID: id, userPW: pw, userPWCHK: pwCheck)
        postSignUp(param)
    }

    @IBAction func idCheckButtonAction(_ sender: Any) {
        print("아이디 중복 확인 버튼 클릭")
        
        let id = idTextField.text ?? ""
        let param = IdCheckRequest(id: id)
        postIdCheck(param)
        
    }
    
    
    func postIdCheck(_ parameters: IdCheckRequest) {
        AF.request("http://54.180.25.129:8080/duplicate/id", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: IdCheckResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if(response.success == true){
                        print(response.message)
                        //성공 로직
                        idCheckButton.setTitle("사용 가능한 아이디입니다", for: .normal)
                        idCheckButton.setTitleColor(.gray, for: .normal)
                        signUpButton.isEnabled = true
                    }
                    
                    else{
                        print(response.message)
                        //실패 알림
                        let idCheckFailAlert = UIAlertController(title: "경고", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        
                        let idCheckFailAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                        idCheckFailAlert.addAction(idCheckFailAction)
                        self.present(idCheckFailAlert, animated: true, completion: nil)
                        
                        idTextField.text = ""
                        
                    }
                    
                case .failure(let error):
                    print("서버 통신 실패")
                    let idCheckFailAlert = UIAlertController(title: "경고", message: "서버 통신에 실패하였습니다.", preferredStyle: UIAlertController.Style.alert)
                    
                    let idCheckFailAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                    idCheckFailAlert.addAction(idCheckFailAction)
                    self.present(idCheckFailAlert, animated: true, completion: nil)
                    
                }
                
            }
    }
    
    
    func postPwCheck(_ parameters: PwCheckRequest) {
        AF.request("http://54.180.25.129:8080/password/check", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: PwCheckResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if(response.success == true){
                        print(response.message)
                        //성공 로직
                        pwCheckListLabel.textColor = .gray
                    }
                    
                    else{
                        print(response.message)
                        //실패 로직
                        pwCheckListLabel.textColor = .red
                    }
                    
                case .failure(let error):
                    print("서버 통신 실패")
                    let pwCheckFailAlert = UIAlertController(title: "경고", message: "서버 통신에 실패하였습니다.", preferredStyle: UIAlertController.Style.alert)
                    
                    let pwCheckFailAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                    pwCheckFailAlert.addAction(pwCheckFailAction)
                    self.present(pwCheckFailAlert, animated: true, completion: nil)
                
                    
                
                }
            }
    }
    
    func postSignUp(_ parameters: SignUpRequest) {
        AF.request("http://54.180.25.129:8080/join", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: SignUpResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if(response.success == true){
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
