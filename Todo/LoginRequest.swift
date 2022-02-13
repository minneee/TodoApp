//
//  LoginRequest.swift
//  Todo
//
//  Created by mini on 2022/02/12.
//

import Foundation
import UIKit

struct LoginRequest: Encodable {
    var userid: String
    var userpw: String
}
