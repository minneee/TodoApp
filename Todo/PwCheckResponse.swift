//
//  PwCheckResponse.swift
//  Todo
//
//  Created by 김민희 on 2022/10/03.
//

import Foundation
import UIKit

struct PwCheckResponse: Decodable {
    var statusCode: Int
    var message: String
    var success: Bool
}
