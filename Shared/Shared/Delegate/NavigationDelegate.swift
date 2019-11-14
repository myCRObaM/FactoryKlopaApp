//
//  NavigationDelegate.swift
//  Shared
//
//  Created by Matej Hetzel on 21/10/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
public protocol NewOrderScreenDelegate: class {
    func openNewOrder()
}

public protocol HistoryOrderScreenDelegate: class {
    func openHistoryOrder()
}
