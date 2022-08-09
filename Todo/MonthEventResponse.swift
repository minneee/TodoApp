//
//  MonthEventResponse.swift
//  Todo
//
//  Created by 김민희 on 2022/08/09.
//

import Foundation
import UIKit

struct MonthEventResponse: Decodable {
    var statusCode: Int
    var data: [EventDate]
    var message: String
    var success: Bool
}

struct EventDate: Decodable {
    var date: String
    var count: String
}
