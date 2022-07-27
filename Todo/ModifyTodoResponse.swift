//
//  ModifyTodoResponse.swift
//  Todo
//
//  Created by 김민희 on 2022/07/27.
//

import Foundation
import UIKit

struct ModifyTodoResponse: Decodable {
    var statusCode: Int
    var data: Int?
    var message: String
    var success: Bool
}
