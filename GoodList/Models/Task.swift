//
//  Task.swift
//  GoodList
//
//  Created by Nurtugan Nuraly on 10/1/20.
//  Copyright © 2020 XFamily, LLC. All rights reserved.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}
