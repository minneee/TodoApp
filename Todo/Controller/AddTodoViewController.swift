//
//  AddTodoViewController.swift
//  Todo
//
//  Created by 김민희 on 2022/02/13.
//

import UIKit
import Alamofire

class AddTodoViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var contentTextField: UITextView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var addButton: UIButton!
    
    var todoDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        todoDate = formatter.string(from: date as Date)

    }
    
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        todoDate = formatter.string(from: sender.date)
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        let title = titleTextField.text ?? ""
        let content = contentTextField.text ?? ""
        let userid = UserDefaults.standard.string(forKey: "id") ?? ""
        
        let param = AddTodoRequest(title: title, content: content, userid: userid, date: todoDate ?? "")
        print(todoDate)
        print(userid)
        postAddTodo(param)
    }

    func postAddTodo(_ parameters: AddTodoRequest) {
        AF.request("http://13.209.10.30:4004/todo", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: AddTodoResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if(response.isSuccess == true){
                        print("투두 추가 성공")
                        print(response.message)
                        self.navigationController?.popViewController(animated: true)
                    }
                    else{
                        print("투두 추가 실패")
                        
                        let addTodoFailAlert = UIAlertController(title: "경고", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        
                        let addTodoFailAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                        addTodoFailAlert.addAction(addTodoFailAction)
                        self.present(addTodoFailAlert, animated: true, completion: nil)
                    }
                    
                case .failure(let error):
                    print("서버 통신 실패\(error.localizedDescription)")
                    
                    let FailAlert = UIAlertController(title: "경고", message: "서버 통신에 실패하였습니다.", preferredStyle: UIAlertController.Style.alert)
                    
                    let FailAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                    FailAlert.addAction(FailAction)
                    self.present(FailAlert, animated: true, completion: nil)
                }
                
            }
    }
}
