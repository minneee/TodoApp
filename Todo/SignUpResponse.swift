//
//  SignUpResponse.swift
//  Todo
//
//  Created by mini on 2022/02/12.
//

import Foundation
import UIKit

struct SignUpResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String?
    var username:String?
    var userid: String?
}
