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
    
    var todoList: [TodoListResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        todoTableView.estimatedRowHeight = 50 //cell 최소 높이
        todoTableView.rowHeight = UITableView.automaticDimension //50 이상일 때 동적 높이
        
        self.todoTableView.delegate = self
        self.todoTableView.dataSource = self
        self.todoTableView.register(UINib(nibName: "TodoTableViewCell", bundle: nil),  forCellReuseIdentifier: "TodoTableViewCell")
    }

}

extension TodoCalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        
        return userCell
    }
    
    
}
