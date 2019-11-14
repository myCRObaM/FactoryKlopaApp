//
//  MealsScreenModel.swift
//  NewOrderScreen
//
//  Created by Matej Hetzel on 31/10/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import RxSwift
import Shared

class MealsScreenModel {
    
    //MARK: Defining structs
    struct Input {
        var loadScreenData: ReplaySubject<Bool>
    }
    
    struct Output {
        var dataReady: ReplaySubject<Bool>
        var disposables: [Disposable]
        var expandableHandler: PublishSubject<ExpansionEnum>
    }
    
    struct Dependencies {
        var scheduler: SchedulerType
        var meals: Restoraunts
    }
    
    //MARK: Variables
    var dependencies: Dependencies
    var input: Input!
    var output: Output!
    
    //MARK: Init
    init(dependencies: MealsScreenModel.Dependencies) {
        self.dependencies = dependencies
    }
    
    //MARK: Transform
    func transform(input: MealsScreenModel.Input) -> MealsScreenModel.Output {
        self.input = input
        var disposables = [Disposable]()
        
        disposables.append(setupData(subject: input.loadScreenData))
        
        self.output = Output(dataReady: ReplaySubject<Bool>.create(bufferSize: 1), disposables: disposables, expandableHandler: PublishSubject())
        return output
    }
    
    func setupData(subject: ReplaySubject<Bool>) -> Disposable {
        return subject
        .observeOn(MainScheduler.instance)
        .subscribeOn(dependencies.scheduler)
            .map({[unowned self] bool in
                self.dependencies.meals.meals[0].isCollapsed = false
        })
            .subscribe(onNext: { [unowned self] bool in
                self.output.dataReady.onNext(true)
            })
    }
    
    func returnHeaderName(meal: MealTypes) -> String {
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
    
    func isPizza(category: String) -> Bool {
        return category == "Pizza"
    }
    
    func numberOfRows(section: Int) -> Int{
        if dependencies.meals.meals[section].isCollapsed {
            return 0
        }
        else {
            return dependencies.meals.meals[section].meals.count
        }
    }
    
    func expandableHandler(section: Int) {
        var indexpath = [IndexPath]()
        
        for (n, _) in dependencies.meals.meals[section].meals.enumerated(){
            indexpath.append(IndexPath(row: n, section: section))
        }
        
        
        
        if dependencies.meals.meals[section].isCollapsed {
            dependencies.meals.meals[section].isCollapsed = false
            self.output.expandableHandler.onNext(.expand(indexpath))
        }
        else {
            dependencies.meals.meals[section].isCollapsed = true
            self.output.expandableHandler.onNext(.colapse(indexpath))
        }
    }
    
    func isButtonSelected(section: Int) -> Bool {
        return !dependencies.meals.meals[section].isCollapsed
    }
}
