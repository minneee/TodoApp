//
//  DeleteTodoResponse.swift
//  Todo
//
//  Created by 김민희 on 2022/02/14.
//

import Foundation
import UIKit

struct DeleteTodoResponse: Decodable {
    var statusCode: Int
    var data: Int?
    var message: String
    var success: Bool
}
