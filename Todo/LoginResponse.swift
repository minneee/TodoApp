//
//  LoginResponse.swift
//  Todo
//
//  Created by mini on 2022/02/12.
//

import Foundation
import UIKit

struct LoginResponse: Decodable {
    var statusCode: Int
    var data: String?
    var message: String
    var success: Bool
}
