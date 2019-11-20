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


public class RestorauntMealTypesModel  {
    //MARK: Define structs
    public struct Input {
        public var getData: ReplaySubject<Bool>
        
        public init(getData: ReplaySubject<Bool>){
            self.getData = getData
        }
    }
    
    public struct Output {
        public var dataReady: ReplaySubject<Bool>
        public var disposables: [Disposable]
        
        public init(dataReady: ReplaySubject<Bool>, disposables: [Disposable]){
            self.dataReady = dataReady
            self.disposables = disposables
        }
    }
    
    public struct Dependencies {
        public var scheduler: SchedulerType
        public var mealCategory: MealCategory
        
        public init(scheduler: SchedulerType, mealCategory: MealCategory){
            self.scheduler = scheduler
            self.mealCategory = mealCategory
        }
    }
    
    //MARK: Variables
    public let dependencies: Dependencies
    public var input: Input!
    public var output: Output!
    
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    //MARK: Transfrom
    public func transform(input: RestorauntMealTypesModel.Input) -> RestorauntMealTypesModel.Output {
        self.input = input
        var disposables = [Disposable]()
        
        disposables.append(prepareData(subject: input.getData))
        
        self.output = Output(dataReady: ReplaySubject<Bool>.create(bufferSize: 1), disposables: disposables)
        return output
    }
    
    public func prepareData(subject: ReplaySubject<Bool>) -> Disposable {
        return subject
        .observeOn(MainScheduler.instance)
        .subscribeOn(dependencies.scheduler)
        .subscribe(onNext: { [unowned self] bool in
            self.output.dataReady.onNext(true)
        })
    }
    
    public func returnLabelData(meal: MealCategory) -> String {
        switch meal.type {
        case .desert:
            return "Desert"
        case .additions:
            return "Dodatci"
        case .hamburgers:
            return "Hamburger"
        case .mealsByOrder:
            return "Jela po narudzbi"
        case .grillMeals:
            return "Jela s rostilja"
        case .kebab:
            return "Kebab"
        case .other:
            return "Ostalo"
        case .pizza:
            return "Pizza"
        case .side:
            return "Prilozi"
        case .fishMeals:
            return "Riblja jela"
        case .riceMeals:
            return "Rizoto"
        case .salad:
            return "Salata"
        case .sendwich:
            return "Sendvic"
        case .pasta:
            return "Tjestenina"
        }
    }
    public func didSelectRow(mealWithName: [MealsWithRestoraunt], name: String) -> [MealsWithRestoraunt]{
        var array = [MealsWithRestoraunt]()
        
        for meal in mealWithName {
            if meal.name == name{
                if mealWithName[0].isPizza == true {
                    array.append(MealsWithRestoraunt(name: meal.name, priceNormal: meal.priceNormal, priceJumbo: meal.priceJumbo, price: meal.price, ingredients: meal.ingredients, restorauntName: meal.restorauntName, mobLabel: meal.mobLabel, telLabel: meal.telLabel, isPizza: true))
                }
                else {
                    array.append(MealsWithRestoraunt(name: meal.name, priceNormal: meal.priceNormal, priceJumbo: meal.priceJumbo, price: meal.price, ingredients: meal.ingredients, restorauntName: meal.restorauntName, mobLabel: meal.mobLabel, telLabel: meal.telLabel))
                }
            }
        }
        return array
        
    }
}
