//
//  DeleteTodoRequest.swift
//  Todo
//
//  Created by 김민희 on 2022/02/14.
//

import Foundation
import UIKit

struct DeleteTodoRequest: Encodable {
    var uuid: String
    var todo_id: Int
}
