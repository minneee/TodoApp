//
//  PwChangeRequset.swift
//  Todo
//
//  Created by 김민희 on 2022/10/17.
//

import Foundation
import UIKit

struct PwChangeRequset: Encodable {
    var uuid: String
    var password: String
    var checkPassword: String
}
