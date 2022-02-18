//
//  TodoCalendarViewController.swift
//  Todo
//
//  Created by mini on 2022/02/12.
//

import UIKit
import Alamofire
import FSCalendar


class TodoCalendarViewController: UIViewController {

    @IBOutlet weak var todoCalendar: FSCalendar!
    
    @IBOutlet weak var todoTableView: UITableView!
    
    @IBOutlet weak var plusButton: UIBarButtonItem!
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    var todoList: [UserTodoList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        todoTableView.estimatedRowHeight = 50 //cell 최소 높이
        todoTableView.rowHeight = UITableView.automaticDimension //50 이상일 때 동적 높이
        
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
        userCell.cellTitleLabel.text = todoData.title
        userCell.cellTimeLabel.text = todoData.date
        userCell.cellContentLabel.text = todoData.content

        return userCell
    }
    
    
}
