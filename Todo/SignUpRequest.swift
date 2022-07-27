//
//  SignUpRequest.swift
//  Todo
//
//  Created by mini on 2022/02/12.
//

import Foundation
import UIKit

struct SignUpRequest: Encodable {
    var userNM: String
    var userID: String
    var userPW: String
    var userPWCHK: String
}
