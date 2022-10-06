//
//  WithdrawResponse.swift
//  Todo
//
//  Created by 김민희 on 2022/10/07.
//

import Foundation
import UIKit

struct WithdrawResponse: Decodable {
    var statusCode: Int
    var data: String?
    var message: String
    var success: Bool
}
