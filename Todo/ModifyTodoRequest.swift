//
//  ModifyTodoRequest.swift
//  Todo
//
//  Created by 김민희 on 2022/07/27.
//

import Foundation
import UIKit

struct ModifyTodoRequest: Encodable {
    var uuid: String
    var todo_id: Int
    var title: String
    var content: String?
    var deadline: TodoDeadlineRequset
}
