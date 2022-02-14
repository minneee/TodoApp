//
//  AddTodoResponse.swift
//  Todo
//
//  Created by 김민희 on 2022/02/14.
//

import Foundation
import UIKit

struct AddTodoResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    
}
