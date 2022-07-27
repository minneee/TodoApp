//
//  TodoListResponse.swift
//  Todo
//
//  Created by 김민희 on 2022/02/14.
//

import Foundation
import UIKit

struct TodoListResponse: Decodable {
    var statusCode: Int
    var data: [UserTodoList]
    var message: String
    var success: Bool
}

struct UserTodoList: Decodable {
    var id: Int
    var title: String
    var content: String?
    var deadline: TodoDeadlineResponse
    var create_time: String
    var status: String
    
}

struct TodoDeadlineResponse: Decodable {
    var date: String
    var time: String?
}
