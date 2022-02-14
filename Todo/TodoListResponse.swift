//
//  TodoListResponse.swift
//  Todo
//
//  Created by 김민희 on 2022/02/14.
//

import Foundation
import UIKit

struct TodoListResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var todo: [UserTodoList]
}

struct UserTodoList: Decodable {
    var no: Int
    var title: String
    var content: String
    var userid: String
    var date: String
}
