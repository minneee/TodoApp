//
//  LoginResponse.swift
//  Todo
//
//  Created by mini on 2022/02/12.
//

import Foundation
import UIKit

struct LoginResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String?
    var Error: String?
}
