//
//  AddTodoRequest.swift
//  Todo
//
//  Created by 김민희 on 2022/02/14.
//

import Foundation
import UIKit

struct AddTodoRequest: Encodable {
    var uuid: String
    var title: String
    var content: String?
    var deadline: TodoDeadlineRequset
}

struct TodoDeadlineRequset: Encodable {
    var date: String
    var time: String?
}
