//
//  IdCheckResponse.swift
//  Todo
//
//  Created by 김민희 on 2022/10/03.
//

import Foundation
import UIKit

struct IdCheckResponse: Decodable {
    var statusCode: Int
    var data: String?
    var message: String
    var success: Bool
}
