//
//  SignUpRequest.swift
//  Todo
//
//  Created by mini on 2022/02/12.
//

import Foundation
import UIKit

struct SignUpRequset: Encodable {
    var username: String
    var userid: String
    var userpw: String
    var userpw_check: String
}
