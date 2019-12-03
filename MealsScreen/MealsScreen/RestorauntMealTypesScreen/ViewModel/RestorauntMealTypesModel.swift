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
        var errorSubject: PublishSubject<Bool>
        var disposables: [Disposable]
    }
    
    struct Dependencies {
        var scheduler: SchedulerType
        var mealCategory: MealCategory
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
        
        self.output = Output(dataReady: ReplaySubject<Bool>.create(bufferSize: 1), errorSubject: PublishSubject<Bool>(), disposables: disposables)
        return output
    }
    
    func prepareData(subject: ReplaySubject<Bool>) -> Disposable {
        return subject
            .observeOn(MainScheduler.instance)
            .subscribeOn(dependencies.scheduler)
            .subscribe(onNext: { [unowned self] bool in
                self.output.dataReady.onNext(true)
                },  onError: {[unowned self] (error) in
                    self.output.errorSubject.onNext(true)
                    print(error)
            })
    }
    
    func returnLabelData(meal: MealCategory) -> String {
        switch meal.type {
        case .desert:
            return NSLocalizedString("mealType_Desert", comment: "")
        case .additions:
            return NSLocalizedString("mealType_Dodatci", comment: "")
        case .hamburgers:
            return NSLocalizedString("mealType_Hamburger", comment: "")
        case .mealsByOrder:
            return NSLocalizedString("mealType_MBO", comment: "")
        case .grillMeals:
            return NSLocalizedString("mealType_GM", comment: "")
        case .kebab:
            return NSLocalizedString("mealType_Kebab", comment: "")
        case .other:
            return NSLocalizedString("mealType_Ostalo", comment: "")
        case .pizza:
            return NSLocalizedString("mealType_Pizza", comment: "")
        case .side:
            return NSLocalizedString("mealType_Prilozi", comment: "")
        case .fishMeals:
            return NSLocalizedString("mealType_Fish", comment: "")
        case .riceMeals:
            return NSLocalizedString("mealType_Rice", comment: "")
        case .salad:
            return NSLocalizedString("mealType_Salad", comment: "")
        case .sendwich:
            return NSLocalizedString("mealType_Sendvich", comment: "")
        case .pasta:
            return NSLocalizedString("mealType_Pasta", comment: "")
        }
    }
    
    func didSelectRow(mealWithName: [MealsWithRestoraunt], name: String) -> [MealsWithRestoraunt]{
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

