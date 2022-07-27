//
//  TodoListRequest.swift
//  Todo
//
//  Created by 김민희 on 2022/02/14.
//

import Foundation
import UIKit

struct TodoListRequest: Encodable {
    var uuid: String
    var deadline: TodoDeadlineDateRequset
}

struct TodoDeadlineDateRequset: Encodable {
    var date: String
}
