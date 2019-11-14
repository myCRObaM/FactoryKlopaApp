//
//  File.swift
//  NewOrderScreen
//
//  Created by Matej Hetzel on 28/10/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import Shared
import RxSwift


class RestorauntMealTypesModel  {
    //MARK: Define structs
    struct Input {
        var getData: ReplaySubject<Bool>
    }
    
    struct Output {
        var dataReady: ReplaySubject<Bool>
        var disposables: [Disposable]
    }
    
    struct Dependencies {
        var scheduler: SchedulerType
        var restoraunts: MealTypes
    }
    
    //MARK: Variables
    let dependencies: Dependencies
    var input: Input!
    var output: Output!
    
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    //MARK: Transfrom
    func transform(input: RestorauntMealTypesModel.Input) -> RestorauntMealTypesModel.Output {
        self.input = input
        var disposables = [Disposable]()
        
        disposables.append(prepareData(subject: input.getData))
        
        self.output = Output(dataReady: ReplaySubject<Bool>.create(bufferSize: 1), disposables: disposables)
        return output
    }
    
    func prepareData(subject: ReplaySubject<Bool>) -> Disposable {
        return subject
        .observeOn(MainScheduler.instance)
        .subscribeOn(dependencies.scheduler)
        .subscribe(onNext: { [unowned self] bool in
            self.output.dataReady.onNext(true)
        })
    }
}
