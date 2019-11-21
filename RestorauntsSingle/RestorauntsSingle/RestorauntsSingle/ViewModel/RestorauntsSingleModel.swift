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

public class RestorauntsSingleModel {
    
    //MARK: Defining structs
    public struct Input {
        public var loadScreenData: ReplaySubject<Bool>
        public var saveMeal: PublishSubject<IndexPath>
        public init(loadScreenData: ReplaySubject<Bool>, saveMeal: PublishSubject<IndexPath>){
            self.loadScreenData = loadScreenData
            self.saveMeal = saveMeal
        }
    }
    
    public struct Output {
        public var dataReady: ReplaySubject<Bool>
        public var disposables: [Disposable]
        public var expandableHandler: PublishSubject<ExpansionEnum>
        
        public init(dataReady: ReplaySubject<Bool>, disposables: [Disposable], expandableHandler: PublishSubject<ExpansionEnum>){
            self.dataReady = dataReady
            self.disposables = disposables
            self.expandableHandler = expandableHandler
        }
    }
    
    public struct Dependencies {
        public var scheduler: SchedulerType
        public var meals: Restoraunts
        public var realmManager: RealmManager
        
        public init(scheduler: SchedulerType, meals: Restoraunts, realmManager: RealmManager){
            self.scheduler = scheduler
            self.meals = meals
            self.realmManager = realmManager
        }
    }
    
    //MARK: Variables
    public var dependencies: Dependencies
    public var input: Input!
    public var output: Output!
    
    //MARK: Init
    public init(dependencies: RestorauntsSingleModel.Dependencies) {
        self.dependencies = dependencies
    }
    
    //MARK: Transform
    public func transform(input: RestorauntsSingleModel.Input) -> RestorauntsSingleModel.Output {
        self.input = input
        var disposables = [Disposable]()
        
        disposables.append(setupData(subject: input.loadScreenData))
        disposables.append(addMealToWishList(subject: input.saveMeal))
        
        self.output = Output(dataReady: ReplaySubject<Bool>.create(bufferSize: 1), disposables: disposables, expandableHandler: PublishSubject())
        return output
    }
    
    public func setupData(subject: ReplaySubject<Bool>) -> Disposable {
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
    
    public func returnHeaderName(meal: MealTypes) -> String {
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
    
    public func isPizza(category: String) -> Bool {
        return category == "Pizza"
    }
    
    public func numberOfRows(section: Int) -> Int{
        if dependencies.meals.meals[section].isCollapsed {
            return 0
        }
        else {
            return dependencies.meals.meals[section].meals.count
        }
    }
    public func expandableHandler(section: Int) {
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
    public func isCollapsed(section: Int) -> Bool {
        return !dependencies.meals.meals[section].isCollapsed
    }
    
    public func detailsButtonSelected(bool: Bool) -> (Bool, Bool){
        var detailsButtonIsPressed: Bool = true
        if bool {
            detailsButtonIsPressed = true
        }
        else {
            detailsButtonIsPressed = false
        }
        return (detailsButtonIsPressed, !detailsButtonIsPressed)
    }
    
    func addMealToWishList(subject: PublishSubject<IndexPath>) -> Disposable {
         return subject
            .flatMap({[unowned self] (bool) -> Observable<String> in
                
                let object = MealsWithRestoraunt(name: self.dependencies.meals.meals[bool.section].meals[bool.row].name, priceNormal: self.dependencies.meals.meals[bool.section].meals[bool.row].priceNormal, priceJumbo: self.dependencies.meals.meals[bool.section].meals[bool.row].priceJumbo, price: self.dependencies.meals.meals[bool.section].meals[bool.row].price, ingredients: self.dependencies.meals.meals[bool.section].meals[bool.row].ingredients, restorauntName: self.dependencies.meals.name, mobLabel: self.dependencies.meals.mob, telLabel: self.dependencies.meals.tel)
                
                
                let meals = self.dependencies.realmManager.saveMeal(meal: object)
                       return meals
                   })
                       .subscribeOn(dependencies.scheduler)
                       .observeOn(MainScheduler.instance)
                       .subscribe(onNext: { (locations) in
                           print("saved")
                })
        }
}
    
