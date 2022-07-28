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
    var todo_id: Int
    var title: String
    var content: String?
    var date: String
    
}



class TodoCalendarViewController: UIViewController {

    @IBOutlet weak var todoCalendar: FSCalendar!
    
    @IBOutlet weak var todoTableView: UITableView!
    
    @IBOutlet weak var plusButton: UIBarButtonItem!
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    
    //var eventDateList: [String] = []
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
        self.todoCalendar.dataSource = self
        self.todoTableView.delegate = self
        self.todoTableView.dataSource = self
        self.todoTableView.register(UINib(nibName: "TodoTableViewCell", bundle: nil),  forCellReuseIdentifier: "TodoTableViewCell")
        
        //탭바 설정
        self.tabBarController?.tabBar.layer.borderWidth = 0.5
        self.tabBarController?.tabBar.layer.borderColor = CGColor(red: 153, green: 153, blue: 153, alpha: 1)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userid = UserDefaults.standard.string(forKey: "id") ?? ""
        let deadline = TodoDeadlineDateRequset(date: selectedDate)
        let param = TodoListRequest(uuid: userid, deadline: deadline)
        postTodoList(param)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func plusButtonAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "todo", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "AddTodoViewController") as! AddTodoViewController
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        //UserDefaults.standard.removeObject(forKey: "auto")
        UserDefaults.standard.set(false, forKey: "auto")
        UserDefaults.standard.removeObject(forKey: "id")

        let logoutAlert = UIAlertController(title: "알림", message: "로그아웃 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        
        let logoutFalseAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: nil)
        let logoutTrueAction = UIAlertAction(title: "로그아웃", style: UIAlertAction.Style.destructive) { ACTION in 
            //루트 컨트롤러 변경
            let storyBD = UIStoryboard(name: "Main", bundle: nil)
            let VC2 = storyBD.instantiateViewController(identifier: "NavController")
            self.changeRootViewController(VC2)
        }
        
        logoutAlert.addAction(logoutFalseAction)
        logoutAlert.addAction(logoutTrueAction)
        self.present(logoutAlert, animated: true, completion: nil)
        
        
        
        
        
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
    
    func postTodoList(_ parameters: TodoListRequest) {
        AF.request("http://54.180.25.129:8080/todo/deadline?page=?", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: TodoListResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.success == true {
                        print("투두 조회 성공")
                        //성공 로직
                        self.todoList = response.data
                        
                        //선택 된 날짜 투두를 새 배열에 저장 --> API 수정으로 이부분도 다시 수정 해야함
                        self.selectedList.removeAll()
                        
                        for index in 0..<todoList.count {
                            let arr = todoList[index].deadline.date.components(separatedBy: " ")
                            if arr[0] == selectedDate {
                                print("새 배열에 저장")
                                let data = todoList[index]
                                let todoData: selectedtodo = selectedtodo(todo_id: data.todo_id, title: data.title, content: data.content, date: data.deadline.date)
                                self.selectedList.append(todoData)
                            }
                        }
                        
                        print("!!!!!!!\(selectedList)")
                        
                        self.todoTableView.reloadData()
                        self.todoCalendar.reloadData()
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
        AF.request("http://54.180.25.129:8080/todo", method: .delete, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: DeleteTodoResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    if response.success == true {
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
        let detailContent = self.selectedList[indexPath.row].content
        let detailNo = self.selectedList[indexPath.row].no
        
        VC.receiveTitle = detailTitle
        VC.receiveDate = detailDate
        VC.receiveContent = detailContent
        VC.receiveNo = detailNo
        
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("투두 삭제 버튼 클릭")
            let deleteAlert = UIAlertController(title: "알림", message: "할 일을 삭제하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
            
            let deleteFailAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: nil)
            let deleteTrueAction = UIAlertAction(title: "삭제", style: UIAlertAction.Style.destructive, handler: { ACTION in
                let userid = UserDefaults.standard.string(forKey: "id") ?? ""
                let no = self.selectedList[indexPath.row].no
                let param = DeleteTodoRequest(no: no, userid: userid)
                self.postDeleteTodo(param)
            })
            deleteAlert.addAction(deleteFailAction)
            deleteAlert.addAction(deleteTrueAction)
            self.present(deleteAlert, animated: true, completion: nil)
            
            
            
            
            
            
        }
    }
}

extension TodoCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
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
    

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        var eventDateList: [String] = []
        print(todoList.count)
        for index in 0..<todoList.count {
            let arr = todoList[index].date.components(separatedBy: " ")
            eventDateList.append(arr[0])
            print("@@@!!\(eventDateList)")
        }
        
        print("+++\(eventDateList)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let eDate = dateFormatter.string(from: date)
        
        if eventDateList.contains(eDate) {
            return 1
        }
        else {
            return 0
        }
    }
    
    
}
