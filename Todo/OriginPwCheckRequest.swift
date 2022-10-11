//
//  OriginPwCheckRequest.swift
//  Todo
//
//  Created by 김민희 on 2022/10/11.
//

import Foundation
import UIKit

struct OriginPwCheckRequest: Encodable {
    var uuid: String
    var password: String
}
