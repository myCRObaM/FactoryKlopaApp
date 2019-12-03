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

class RestorauntsSingleModel {
    
    //MARK: Defining structs
    struct Input {
        var loadScreenData: ReplaySubject<Bool>
        var saveMeal: PublishSubject<SaveToListEnum>
        var screenSelectionButtonSubject: PublishSubject<Bool>
    }
    
    struct Output {
        var dataReady: ReplaySubject<Bool>
        var disposables: [Disposable]
        var screenData: RestorauntsSingleScreenStruct!
        var expandableHandler: PublishSubject<ExpansionEnum>
        var errorSubject: PublishSubject<Bool>
        var popupSubject: PublishSubject<Bool>
        var buttonStateSubject: PublishSubject<Bool>
    }
    
    struct Dependencies {
        var scheduler: SchedulerType
        var meals: Restoraunts
        var realmManager: RealmManager
    }
    
    //MARK: Variables
    var dependencies: Dependencies
    var input: Input!
    var output: Output!
    
    //MARK: Init
    init(dependencies: RestorauntsSingleModel.Dependencies) {
        self.dependencies = dependencies
    }
    
    //MARK: Transform
    func transform(input: RestorauntsSingleModel.Input) -> RestorauntsSingleModel.Output {
        self.input = input
        var disposables = [Disposable]()
        
        disposables.append(setupData(subject: input.loadScreenData))
        disposables.append(addMealToWishList(subject: input.saveMeal))
        disposables.append(setupButtonState(subject: input.screenSelectionButtonSubject))
        
        self.output = Output(dataReady: ReplaySubject<Bool>.create(bufferSize: 1), disposables: disposables, screenData: nil, expandableHandler: PublishSubject(), errorSubject: PublishSubject<Bool>(), popupSubject: PublishSubject<Bool>(), buttonStateSubject: PublishSubject<Bool>())
        return output
    }
    //MARK: Setup data
    func setupData(subject: ReplaySubject<Bool>) -> Disposable {
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
        var meals = [Meals]()
        for (n, mealType) in data.meals.enumerated() {
            if n == 0 {
                for meal in mealType.meals {
                    meals.append(meal)
                }
                section.append(Section(type: mealType.type, data: meals))
                section[0].isCollapsed = false
                meals.removeAll()
            }
            else {
                section.append(Section(type: mealType.type, data: meals))
                meals.removeAll()
            }
            
        }
        return RestorauntsSingleScreenStruct(title: data.name, mob: data.mob, tel: data.tel, workingHours: data.workingHours ?? "", section: section)
    }
    //MARK: Header Name
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
    //MARK: Pizza check functions
    func isPizza(category: String) -> Bool {
        return category == "Pizza"
    }
    
    func hasJumboPrice(price: String) -> Bool {
        return !(price == "")
    }
    
    //MARK: Expandable hander
    func expandableHandler(section: Int, data: [Meals]) {
        var indexpath = [IndexPath]()
        
        if output.screenData.section[section].isCollapsed {
            for meal in data{
                output.screenData.section[section].data.append(meal)
            }
        }
        else {
            output.screenData.section[section].data.removeAll()
        }
        
        
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
    func isCollapsed(section: Section) -> Bool {
        return section.isCollapsed
    }
    
    //MARK: Add meal to wish list
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
    //MARK: Cell data
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
    //MARK: Setup button state
    func setupButtonState(subject: PublishSubject<Bool>) -> Disposable {
        return subject
            .observeOn(MainScheduler.instance)
            .subscribeOn(dependencies.scheduler)
            .subscribe(onNext: { [unowned self] bool in
                self.output.buttonStateSubject.onNext(bool)
            })
    }
    
}



