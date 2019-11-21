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


public class SortedByMealNameModel {
    //MARK: Struct declaration
    public struct Input
    {
        public var getData: ReplaySubject<Bool>
        
        public init(getData: ReplaySubject<Bool>){
            self.getData = getData
        }
    }
    
    public struct Output
    {
        public var dataReady: ReplaySubject<Bool>
        public var disposables: [Disposable]
        
        public init(dataReady: ReplaySubject<Bool>, disposables: [Disposable]){
            self.dataReady = dataReady
            self.disposables = disposables
        }
    }
    
    public struct Dependencies
    {
        public var meals: [MealsWithRestoraunt]
        public var scheduler: SchedulerType
        
        public init(meals: [MealsWithRestoraunt], scheduler: SchedulerType){
            self.meals = meals
            self.scheduler = scheduler
        }
    }
    
    //MARK: Variables
    public let dependencies: Dependencies
    public var input: Input!
    public var output: Output!
    
    //MARK: init
    public init(dependencies: SortedByMealNameModel.Dependencies) {
        self.dependencies = dependencies
    }
    
    //MARK: Transform
    public func transform(input: SortedByMealNameModel.Input) -> SortedByMealNameModel.Output {
        self.input = input
        var disposables = [Disposable]()
        
        disposables.append(getData(subject: input.getData))
        
        output = Output(dataReady: ReplaySubject<Bool>.create(bufferSize: 1), disposables: disposables)
        return output
    }
    //MARK: getData
    public func getData(subject: ReplaySubject<Bool>) -> Disposable {
        return subject
        .observeOn(MainScheduler.instance)
        .subscribeOn(dependencies.scheduler)
        .subscribe(onNext: { [unowned self] bool in
            self.output.dataReady.onNext(true)
        })
    }
    
    public func isPizza(meal: MealsWithRestoraunt) -> Bool {
        if meal.isPizza {
            return true
        }
        else {
            return false
        }
    }
}
