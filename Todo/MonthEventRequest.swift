//
//  MonthEventRequest.swift
//  Todo
//
//  Created by 김민희 on 2022/08/09.
//

import Foundation
import UIKit

struct MonthEventRequest: Encodable {
    var uuid: String
    var year: String
    var month: String
}
