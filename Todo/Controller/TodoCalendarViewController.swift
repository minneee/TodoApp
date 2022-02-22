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
    var nowDate = ""
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
        
        //탭바 설정
        self.tabBarController?.tabBar.layer.borderWidth = 0.5
        self.tabBarController?.tabBar.layer.borderColor = CGColor(red: 153, green: 153, blue: 153, alpha: 1)
        
        /*
        //루트 컨트롤러 변경
        let storyBoard = UIStoryboard(name: "todo", bundle: nil)
        let VC = storyBoard.instantiateViewController(identifier: "NavController")
        changeRootViewController(VC)
         */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        todoCalendar.appearance.selectionColor = UIColor(white: 1, alpha: 0)
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
                        /*
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy/MM/dd"
                        selectedDate = dateFormatter.string(from: Date())
                          */
                        //선택 된 날짜 투두를 새 배열에 저장
                        self.selectedList.removeAll()
                        
                        for index in 0..<todoList.count {
                            let arr = todoList[index].date.components(separatedBy: " ")
                            if arr[0] == selectedDate {
                                print("새 배열에 저장")
                                let data = todoList[index]
                                let todoData: selectedtodo = selectedtodo(no: data.no, title: data.title, content: data.content, userid: data.userid, date: data.date)
                                self.selectedList.append(todoData)
                            }
                        }
                        
                        print("!!!!!!!\(selectedList)")
                        
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
    
    func postDeleteTodo(_ parameters: DeleteTodoRequest) {
        AF.request("http://13.209.10.30:4004/todo/delete", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: DeleteTodoResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.isSuccess == true {
                        print(response.message)
                        //성공 로직
                        let userid = UserDefaults.standard.string(forKey: "id") ?? ""
                        let param = TodoListRequest(userid: userid)
                        postTodoList(param)
                    }
                    else{
                        print(response.message)
                        //실패 로직
                        let deleteFailAlert = UIAlertController(title: "경고", message: response.message, preferredStyle: UIAlertController.Style.alert)
                        
                        let deleteFailAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                        deleteFailAlert.addAction(deleteFailAction)
                        self.present(deleteFailAlert, animated: true, completion: nil)
                    }
                
                case .failure(let error):
                    print("서버 통신 실패\(error.localizedDescription)")
                    let signUpFailAlert = UIAlertController(title: "경고", message: "서버 통신에 실패하였습니다.", preferredStyle: UIAlertController.Style.alert)
                    
                    let signUpFailAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                    signUpFailAlert.addAction(signUpFailAction)
                    self.present(signUpFailAlert, animated: true, completion: nil)
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

extension TodoCalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return selectedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        
        let todoData = self.selectedList[indexPath.row]
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
        
        let detailTitle = self.selectedList[indexPath.row].title
        let detailDate = self.selectedList[indexPath.row].date
        let deTailContent = self.selectedList[indexPath.row].content
        
        VC.receiveTitle = detailTitle
        VC.receiveDate = detailDate
        VC.receiveContent = deTailContent
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("투두 삭제 버튼 클릭")
            //selectedList.remove(at: indexPath.row)
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            let userid = UserDefaults.standard.string(forKey: "id") ?? ""
            let no = selectedList[indexPath.row].no
            let param = DeleteTodoRequest(no: no, userid: userid)
            postDeleteTodo(param)
            
            
        }
    }
}

extension TodoCalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        todoCalendar.appearance.selectionColor = UIColor(white: 1, alpha: 1)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        selectedDate = dateFormatter.string(from: date)
        print(selectedDate)
        
        //이전 데이터 누적을 피하기 위해 배열 초기화
        self.selectedList.removeAll()
        
        //선택된 날짜의 투두를 배열에 저장
        for index in 0..<todoList.count {
            let arr = todoList[index].date.components(separatedBy: " ")
            if arr[0] == selectedDate {
                print("새 배열에 저장")
                let data = todoList[index]
                let todoData: selectedtodo = selectedtodo(no: data.no, title: data.title, content: data.content, userid: data.userid, date: data.date)
                self.selectedList.append(todoData)
            }
        }
        
        print(">>>>>>\(selectedList)")
        todoTableView.reloadData()
    }
}
