//
//  DataRepository.swift
//  Shared
//
//  Created by Matej Hetzel on 28/10/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import RxSwift
import Shared

public class DataRepo {
    public init() {
        
    }
    public func getData() -> Observable<[RestorauntsModel]> {
        let dataManager = DataManager()
        return dataManager.getData()
    }
}
