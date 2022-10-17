//
//  PwChangeResponse.swift
//  Todo
//
//  Created by 김민희 on 2022/10/17.
//

import Foundation
import UIKit

struct PwChangeResponse: Decodable {
    var statusCode: Int
    var data: String?
    var message: String
    var success: Bool
}
