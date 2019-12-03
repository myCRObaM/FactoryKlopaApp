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
        public var saveMeal: PublishSubject<SaveToListEnum>
        public init(loadScreenData: ReplaySubject<Bool>, saveMeal: PublishSubject<SaveToListEnum>){
            self.loadScreenData = loadScreenData
            self.saveMeal = saveMeal
        }
    }
    
    public struct Output {
        public var dataReady: ReplaySubject<Bool>
        public var disposables: [Disposable]
        var screenData: RestorauntsSingleScreenStruct!
        public var expandableHandler: PublishSubject<ExpansionEnum>
        public var errorSubject: PublishSubject<Bool>
        var popupSubject: PublishSubject<Bool>
        
        public init(dataReady: ReplaySubject<Bool>, disposables: [Disposable], expandableHandler: PublishSubject<ExpansionEnum>, errorSubject: PublishSubject<Bool>, screenData: RestorauntsSingleScreenStruct?, popupSubject: PublishSubject<Bool>){
            self.dataReady = dataReady
            self.disposables = disposables
            self.expandableHandler = expandableHandler
            self.errorSubject = errorSubject
            self.screenData = screenData
            self.popupSubject = popupSubject
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
        
        self.output = Output(dataReady: ReplaySubject<Bool>.create(bufferSize: 1), disposables: disposables, expandableHandler: PublishSubject(), errorSubject: PublishSubject<Bool>(), screenData: nil, popupSubject: PublishSubject<Bool>())
        return output
    }
    
    public func setupData(subject: ReplaySubject<Bool>) -> Disposable {
        return subject
        .observeOn(MainScheduler.instance)
        .subscribeOn(dependencies.scheduler)
            .map({[unowned self] bool in
                self.output.screenData = self.setupScreenData(data: self.dependencies.meals)
           })
            .subscribe(onNext: { [unowned self] bool in
                self.output.dataReady.onNext(true)
            },  onError: {[unowned self] (error) in
                    self.output.errorSubject.onNext(true)
                    print(error)
            })
    }
    
    func setupScreenData(data: Restoraunts) -> RestorauntsSingleScreenStruct {
        var section = [Section]()
        for mealType in data.meals {
            section.append(Section(type: mealType.type, data: mealType.meals))
        }
        if section.count != 0 {
            section[0].isCollapsed = false
        }
        return RestorauntsSingleScreenStruct(title: data.name, mob: data.mob, tel: data.tel, workingHours: data.workingHours ?? "", section: section)
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
    
    func hasJumboPrice(price: String) -> Bool {
        return !(price == "")
    }
    
    
    public func numberOfRows(section: Section) -> Int{
        if section.isCollapsed {
            return 0
        }
        else {
            return section.data.count
        }
    }
    public func expandableHandler(section: Int) {
        var indexpath = [IndexPath]()
        
        for (n, _) in output.screenData.section[section].data.enumerated(){
            indexpath.append(IndexPath(row: n, section: section))
        }
        
        
        
        if output.screenData.section[section].isCollapsed {
            output.screenData.section[section].isCollapsed = false
            self.output.expandableHandler.onNext(.expand(indexpath))
        }
        else {
            output.screenData.section[section].isCollapsed = true
            self.output.expandableHandler.onNext(.colapse(indexpath))
        }
    }
    public func isCollapsed(section: Section) -> Bool {
        return section.isCollapsed
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
    
    func addMealToWishList(subject: PublishSubject<SaveToListEnum>) -> Disposable {
         return subject
            .flatMap({[unowned self] enumValue -> Observable<String> in
                var bool: IndexPath!
                var price: String = ""
                switch enumValue {
                case .jumbo(let index):
                    price = self.dependencies.meals.meals[index.section].meals[index.row].priceJumbo ?? ""
                    bool = index
                case .normal(let index):
                    price = self.dependencies.meals.meals[index.section].meals[index.row].price ?? ""
                    bool = index
                }
                let object = MealsWithRestoraunt(name: self.dependencies.meals.meals[bool.section].meals[bool.row].name, priceNormal: "", priceJumbo: "", price: price, ingredients: self.dependencies.meals.meals[bool.section].meals[bool.row].ingredients, restorauntName: self.dependencies.meals.name, mobLabel: self.dependencies.meals.mob, telLabel: self.dependencies.meals.tel)
                
                
                let meals = self.dependencies.realmManager.saveMeal(meal: object)
                       return meals
                   })
                       .subscribeOn(dependencies.scheduler)
                       .observeOn(MainScheduler.instance)
                       .subscribe(onNext: { (locations) in
                        self.output.popupSubject.onNext(true)
                },  onError: {[unowned self] (error) in
                        self.output.errorSubject.onNext(true)
                        print(error)
                })
        }
    
    func setupCellData(data: Meals) -> (String, String, String) {
            var ingredients: String = ""
            let mealName: String = data.name.uppercased()
            var price: String = data.price ?? ""
            if Int(data.priceJumbo ?? "0") ?? 0 > 0 {
                       price = (data.priceNormal ?? "") + "  " + (data.priceJumbo ?? "")
                   }
            if data.ingredients?.count ?? 0 > 0 {
                for ingredient in data.ingredients! {
                    if ingredients != "" {
                        ingredients = ingredients + ", " + ingredient.name!
                    }
                    else {
                        ingredients = ingredient.name!
                    }
                    
                }
                ingredients = "(" + ingredients + ")"
            }
        return (mealName, price, ingredients)
    }
    
    
}


    
