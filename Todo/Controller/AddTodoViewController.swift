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
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var addButton: UIButton!
    
    var todoDate: String?
    var deadlineArr: [String] = []
    
    var modifyTitle = ""
    var modifyDate = ""
    var modifyContent = ""
    var navTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        todoDate = formatter.string(from: date as Date)
        deadlineArr = todoDate!.components(separatedBy: " ")
        
        
        if navTitle == ""{
            self.navigationItem.title = "할일 추가"
        }
        else {
            self.navigationItem.title = navTitle
        }
        
        
        if modifyTitle != "" {
            titleTextField.text = modifyTitle
            contentTextView.text = modifyContent
        }
        
        
        //placeholder
        contentTextView.delegate = self
        
    }
    
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        todoDate = formatter.string(from: sender.date)
        //let arr = todoList[index].deadline.date.components(separatedBy: " ")
        deadlineArr = todoDate!.components(separatedBy: " ")
        print("ggg\(deadlineArr)")
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        let title = titleTextField.text ?? ""
        let content = contentTextView.text ?? ""
        let userid = UserDefaults.standard.string(forKey: "id") ?? ""
        let deadline = TodoDeadlineRequset(date: deadlineArr[0], time: deadlineArr[1])
        let param = AddTodoRequest(uuid: userid, title: title, content: content, deadline: deadline)
        print(todoDate)
        print(userid)
        postAddTodo(param)
    }

    func postAddTodo(_ parameters: AddTodoRequest) {
        AF.request("http://54.180.25.129:8080/todo", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: AddTodoResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if(response.success == true){
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

extension AddTodoViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "여기에 내용을 입력하세요." {
            textView.text = nil
            textView.textColor = .black
        }
        else if textView.text == modifyContent {
            textView.textColor = .black
        }
                    
                    
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "여기에 내용을 입력하세요."
            textView.textColor = .lightGray
        }
        
    }
}
