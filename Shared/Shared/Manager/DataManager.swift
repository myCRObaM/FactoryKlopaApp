//
//  DataManager.swift
//  Shared
//
//  Created by Matej Hetzel on 28/10/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import RxSwift

public class DataManager  {
   public func getData() -> Observable<[RestorauntsModel]> {
        
        return Observable.create{   observable -> Disposable in
            
        let bundle = Bundle(for: DataManager.self)
        let path = bundle.url(forResource: "data", withExtension: "json")
        do {
            let data = try Data(contentsOf: path!)
            let restoraunts = try! JSONDecoder().decode([RestorauntsModel].self, from: data)
            observable.onNext(restoraunts)
        } catch let jsonErr {
            print(jsonErr)
        }
        return Disposables.create()
    }
    }
    public init() {
    }
}
