//
//  TodoCalendarViewController.swift
//  Todo
//
//  Created by mini on 2022/02/12.
//

import UIKit
import Alamofire
import FSCalendar

struct selectedtodo {
    var no: Int
    var title: String
    var content: String
    var userid: String
    var date: String
}
class TodoCalendarViewController: UIViewController {

    @IBOutlet weak var todoCalendar: FSCalendar!
    
    @IBOutlet weak var todoTableView: UITableView!
    
    @IBOutlet weak var plusButton: UIBarButtonItem!
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    var todoList: [UserTodoList] = []
    var selectedList: [selectedtodo] = []
    
    var selectedDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        selectedDate = formatter.string(from: date as Date)
        print(selectedDate)

        todoCalendar.appearance.headerDateFormat = "YYYY년 M월"
        
        todoTableView.estimatedRowHeight = 50 //cell 최소 높이
        todoTableView.rowHeight = UITableView.automaticDimension //50 이상일 때 동적 높이
        
        self.todoCalendar.delegate = self
        self.todoTableView.delegate = self
        self.todoTableView.dataSource = self
        self.todoTableView.register(UINib(nibName: "TodoTableViewCell", bundle: nil),  forCellReuseIdentifier: "TodoTableViewCell")
        
        let userid = UserDefaults.standard.string(forKey: "id") ?? ""
        
        let param = TodoListRequest(userid: userid)
        postTodoList(param)
    }
    
    
    @IBAction func plusButtonAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "todo", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "AddTodoViewController") as! AddTodoViewController
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "auto")
        UserDefaults.standard.removeObject(forKey: "id")

        self.navigationController?.popViewController(animated: true)
    }
    
    func postTodoList(_ parameters: TodoListRequest) {
        AF.request("http://13.209.10.30:4004/todo/list", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: TodoListResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        print("투두 조회 성공")
                        //성공 로직
                        self.todoList = response.todo
                        
                        //오늘 날짜 투두를 새 배열에 저장
                        var count = 0
                        for index in 0..<todoList.count {
                            print(index)
                            let arr = todoList[index].date.components(separatedBy: " ")
                            if arr[0] == selectedDate {
                                selectedList[count].no = todoList[index].no
                                selectedList[count].userid = todoList[index].userid
                                selectedList[count].title = todoList[index].title
                                selectedList[count].content = todoList[index].content
                                selectedList[count].date = todoList[index].date
                                count += 1
                                print(selectedList[count].no)
                            }
                        }
                        
                        print(">>>>>>\(selectedList)")
                        
                        
                        self.todoTableView.reloadData()
                    }
                    else{
                        print("투두 조회 실패")
                        //실패 로직
                        let TodoFailAlert = UIAlertController(title: "경고", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        
                        let TodoFailAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                        TodoFailAlert.addAction(TodoFailAction)
                        self.present(TodoFailAlert, animated: true, completion: nil)
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

extension TodoCalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        
        let todoData = self.todoList[indexPath.row]
        print(todoData.date)
        let arr =  todoData.date.components(separatedBy: " ")
        print("\(arr), \(arr[0])")
        if (arr[0] == selectedDate){
            userCell.cellTitleLabel.text = todoData.title
            userCell.cellTimeLabel.text = todoData.date
            userCell.cellContentLabel.text = todoData.content
           
        } 
        

        return userCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "todo", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "TodoDetailViewController") as! TodoDetailViewController
        self.navigationController?.pushViewController(VC, animated: true)
        
        let detailTitle = self.todoList[indexPath.row].title
        let detailDate = self.todoList[indexPath.row].date
        let deTailContent = self.todoList[indexPath.row].content
        
        VC.receiveTitle = detailTitle
        VC.receiveDate = detailDate
        VC.receiveContent = deTailContent
    }
    
}

extension TodoCalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        selectedDate = dateFormatter.string(from: date)
        print(selectedDate)
        
        //선택된 날짜의 투두를 배열에 저장
        for index in 0..<selectedList.count {
            let arr = todoList[index].date.components(separatedBy: " ")
            if arr[0] == selectedDate {
                selectedList[index].no = todoList[index].no
                selectedList[index].userid = todoList[index].userid
                selectedList[index].title = todoList[index].title
                selectedList[index].content = todoList[index].content
                selectedList[index].date = todoList[index].date
            }
        }
        
        print(">>>>>>\(selectedList.count)")
        todoTableView.reloadData()
    }
}
