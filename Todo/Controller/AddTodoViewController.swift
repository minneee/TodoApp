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
    
    static var selectedDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    /*
    @IBAction func datePickerAction(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/mm/dd HH:mm"
        selectedDate = formatter.string(from: datePicker.date)
    }*/
    
    @IBAction func addButtonAction(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/mm/dd HH:mm"
        
        let title = titleTextField.text ?? ""
        let date = formatter.string(from: datePicker.date)
        let content = contentTextField.text ?? ""
        
        let param = AddTodoRequest(title: title, content: content, userid: "id", data: date)
        
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
