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
        var errorSubject: PublishSubject<Bool>
        var screenData: Section?
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
        
        output = Output(dataReady: ReplaySubject<Bool>.create(bufferSize: 1), disposables: disposables, errorSubject: PublishSubject<Bool>())
        return output
    }
    //MARK: getData
    func getData(subject: ReplaySubject<Bool>) -> Disposable {
        return subject
        .observeOn(MainScheduler.instance)
        .subscribeOn(dependencies.scheduler)
        .map({ bool -> Section in
            return self.setupScreenData(data: self.dependencies.meals)
            })
        .subscribe(onNext: { [unowned self] bool in
            self.output.screenData = bool
            self.output.dataReady.onNext(true)
        },  onError: {[unowned self] (error) in
                self.output.errorSubject.onNext(true)
                print(error)
        })
    }
    
    func setupScreenData(data: [MealsWithRestoraunt]) -> Section {
        let ingRepo = IngredientsOperator()
        var name: String = ""
        var meals = [Rows]()
        
        for meal in data {
            let ingredients = ingRepo.returnIngredients(data: meal)
            name = meal.name
            meals.append(Rows(restorauntName: meal.restorauntName, mob: meal.mobLabel, tel: meal.telLabel, price: meal.price, ingredients: ingredients, priceJumbo: meal.priceJumbo, priceNormal: meal.priceNormal))
        }
        return (Section(mealName: name, data: meals))
    }
    
    func isPizza(meal: MealsWithRestoraunt) -> Bool {
        if meal.isPizza {
            return true
        }
        else {
            return false
        }
    }
}
