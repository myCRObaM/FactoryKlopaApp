//
//  SortedByMealNameModel.swift
//  MealsScreen
//
//  Created by Matej Hetzel on 19/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import Shared
import RxSwift


class SortedByMealNameModel {
    //MARK: Struct declaration
    struct Input
    {
        var getData: ReplaySubject<Bool>
    }
    
    struct Output
    {
        var dataReady: ReplaySubject<Bool>
        var disposables: [Disposable]
    }
    
    struct Dependencies
    {
        var meals: [MealsWithRestoraunt]
        var scheduler: SchedulerType
    }
    
    //MARK: Variables
    let dependencies: Dependencies
    var input: Input!
    var output: Output!
    
    //MARK: init
    init(dependencies: SortedByMealNameModel.Dependencies) {
        self.dependencies = dependencies
    }
    
    //MARK: Transform
    func transform(input: SortedByMealNameModel.Input) -> SortedByMealNameModel.Output {
        self.input = input
        var disposables = [Disposable]()
        
        disposables.append(getData(subject: input.getData))
        
        output = Output(dataReady: ReplaySubject<Bool>.create(bufferSize: 1), disposables: disposables)
        return output
    }
    //MARK: getData
    func getData(subject: ReplaySubject<Bool>) -> Disposable {
        return subject
        .observeOn(MainScheduler.instance)
        .subscribeOn(dependencies.scheduler)
        .subscribe(onNext: { [unowned self] bool in
            self.output.dataReady.onNext(true)
        })
    }
}
