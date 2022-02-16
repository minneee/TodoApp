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
                    }
                    else{
                        print("투두 추가 실패")
                        print(response.message)
                    }
                case .failure(let error):
                    print("서버 통신 실패\(error.localizedDescription)")
                }
                
            }
    }
}
