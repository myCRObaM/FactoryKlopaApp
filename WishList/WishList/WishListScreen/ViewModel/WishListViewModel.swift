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
        var deleteMeal: PublishSubject<IndexPath>
    }
    
    public struct Output {
        var dataReady: ReplaySubject<Bool>
        var errorSubject: PublishSubject<Bool>
        var deleteCell: PublishSubject<IndexPath>
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
    var restoraunts = [("", [Int]())]
    
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
        
        self.output = WishListViewModel.Output(dataReady: ReplaySubject<Bool>.create(bufferSize: 1), errorSubject: PublishSubject<Bool>(), deleteCell: PublishSubject<IndexPath>(), disposables: disposables)
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
                self.restoraunts = self.returnRestoraunts(current: bool)
                self.output.dataReady.onNext(true)
                },  onError: {[unowned self] (error) in
                    self.output.errorSubject.onNext(true)
                    print(error)
            })
    }
    
    func deleteLocation(subject: PublishSubject<IndexPath>) -> Disposable {
        return subject
            .flatMap({[unowned self] (bool) -> Observable<String> in
                let location = self.restoraunts[bool.section].1[bool.row]
                let meals = self.dependencies.realmRepo.deleteMeal(name: self.meals[location].name)
                self.meals.remove(at: location)
                self.output.deleteCell.onNext(bool)
                self.restoraunts = self.returnRestoraunts(current: self.meals)
                if bool.row == 0 {
                    self.output.dataReady.onNext(true)
                }
                return meals
            })
            .subscribeOn(dependencies.scheduler)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (bool) in
                },  onError: {[unowned self] (error) in
                    self.output.errorSubject.onNext(true)
                    print(error)
            })
    }
    
    func returnRestoraunts(current: [MealsWithRestoraunt]) ->[(String, [Int])]{
        var restoraunts = [("", [Int]())]
        var savedRest = false
        var savedIndex = false
        for (n, meal) in current.enumerated() {
            if restoraunts[0].0 == "" {
                restoraunts[0].0 = meal.restorauntName
                restoraunts[0].1.append(n)
            }
            else {
                for saved in restoraunts{
                    if saved.0 == meal.restorauntName {
                        savedRest = true
                    }
                }
                
                if savedRest == false {
                    restoraunts.append((meal.restorauntName, [n]))
                }
                
                for (c, saved) in restoraunts.enumerated() {
                    if saved.0 == meal.restorauntName {
                        for index in saved.1 {
                            if index == n {
                                savedIndex = true
                            }
                        }
                        if savedIndex == false {
                            restoraunts[c].1.append(n)
                        }
                    }
                }
            }
            savedIndex = false
            savedRest = false
        }
        return restoraunts
    }
    func isPizza(data: MealsWithRestoraunt) -> Bool {
        if data.priceJumbo != nil || data.priceNormal != nil {
            return true
        }
        else
        {
            return false
        }
    }
}
