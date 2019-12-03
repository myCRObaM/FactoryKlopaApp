//
//  RestorauntsSingleDataStruct.swift
//  RestorauntsSingle
//
//  Created by Matej Hetzel on 28/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import Shared

public struct RestorauntsSingleScreenStruct {
    var title: String
    var mob: String?
    var tel: String?
    var workingHours: String
    var section: [Section]
}
public struct Section {
    var type: MealTypeEnum
    var data: [Meals]
    var isCollapsed: Bool = true
}
