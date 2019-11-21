//
//  WishListViewModel.swift
//  WishList
//
//  Created by Matej Hetzel on 21/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import RxSwift
import Shared

public class WishListViewModel{
    //MARK: Defining structs
    public struct Input {
        var getData: ReplaySubject<Bool>
        var deleteMeal: PublishSubject<Int>
    }
    
    public struct Output {
        var dataReady: ReplaySubject<Bool>
        var disposables: [Disposable]
    }
    
    public struct Dependencies {
        var scheduler: SchedulerType
        var realmRepo: RealmManager
    }
    //MARK: Variables
    let dependencies: Dependencies
    var input: Input!
    var output: Output!
    var meals = [MealsWithRestoraunt]()
    
    //MARK: init
    public init(dependencies: WishListViewModel.Dependencies){
        self.dependencies = dependencies
    }
    
    //MARK: Transform
    public func transform(input: WishListViewModel.Input) -> WishListViewModel.Output {
        self.input = input
        var disposables = [Disposable]()
        
        disposables.append(getData(subject: input.getData))
        disposables.append(deleteLocation(subject: input.deleteMeal))
        
        
        self.output = WishListViewModel.Output(dataReady: ReplaySubject<Bool>.create(bufferSize: 1), disposables: disposables)
        return output
    }
    
    func getData(subject: ReplaySubject<Bool>) -> Disposable{
        return subject
            .flatMap({[unowned self] (bool) -> Observable<[MealsWithRestoraunt]> in
                
                let meals = self.dependencies.realmRepo.getMeals()
                return Observable.just(meals)
            })
            .subscribeOn(dependencies.scheduler)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (bool) in
                self.meals = bool
                self.output.dataReady.onNext(true)
            })
    }
    
    func deleteLocation(subject: PublishSubject<Int>) -> Disposable {
        return subject
        .flatMap({[unowned self] (bool) -> Observable<String> in
            
            let meals = self.dependencies.realmRepo.deleteMeal(name: self.meals[bool].name)
            self.meals.remove(at: bool)
            return meals
        })
        .subscribeOn(dependencies.scheduler)
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: {[unowned self] (bool) in
            self.output.dataReady.onNext(true)
        })
    }
    
}
