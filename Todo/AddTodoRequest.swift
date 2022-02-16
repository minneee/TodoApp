//
//  AddTodoRequest.swift
//  Todo
//
//  Created by 김민희 on 2022/02/14.
//

import Foundation
import UIKit

struct AddTodoRequest: Encodable {
    var title: String
    var content: String
    var userid: String
    var date: String
}
