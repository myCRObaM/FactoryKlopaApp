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
        var screenData: [Section]?
        var disposables: [Disposable]
        var emptySubject: PublishSubject<Bool>
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
        disposables.append(deleteMeal(subject: input.deleteMeal))
        
        self.output = WishListViewModel.Output(dataReady: ReplaySubject<Bool>.create(bufferSize: 1), errorSubject: PublishSubject<Bool>(), deleteCell: PublishSubject<IndexPath>(), disposables: disposables, emptySubject: PublishSubject<Bool>())
        return output
    }
    //MARK: GetData
    func getData(subject: ReplaySubject<Bool>) -> Disposable{
        return subject
            .flatMap({[unowned self] (bool) -> Observable<[MealsWithRestoraunt]> in
                
                let meals = self.dependencies.realmRepo.getMeals()
                return Observable.just(meals)
            })
            .subscribeOn(dependencies.scheduler)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (bool) in
                if bool.count == 0 {
                    self.output.emptySubject.onNext(true)
                }
                else {
                    self.meals = bool
                    self.output.screenData = self.setupScreenData(data: bool)
                    
                }
                self.output.dataReady.onNext(true)
                },  onError: {[unowned self] (error) in
                    self.output.errorSubject.onNext(true)
                    print(error)
            })
    }
    //MARK: Remove meal from list
    func deleteMeal(subject: PublishSubject<IndexPath>) -> Disposable {
        return subject
            .flatMap({[unowned self] (bool) -> Observable<String> in
                let meals = self.dependencies.realmRepo.deleteMeal(name: self.output!.screenData![bool.section].data[bool.row].mealName)
                self.output!.screenData![bool.section].data.remove(at: bool.row)
                
                if self.output!.screenData![bool.section].data.count == 0 {
                    self.output!.screenData!.remove(at: bool.section)
                }
                self.output.deleteCell.onNext(bool)
                return meals
            })
            .subscribeOn(dependencies.scheduler)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (bool) in
            },  onError: {[unowned self] (error) in
                self.output.errorSubject.onNext(true)
                print(error)
            })
    }
    //MARK: Header data
    func dataForHeader(data: Section) -> (rName: String, mText: String, tText: String, price: String){
        var mob = ""
        var tel = ""
        var price = ""
        
        if data.mob != "" {
            mob = "Mob: " + data.mob
        }
        if data.tel != "" {
            tel = "Tel: " + data.tel
        }
        
        price = NSLocalizedString("price", comment: "")
        
        return (rName: data.restorauntName, mText: mob, tText: tel, price: price)
    }
    //MARK: Return correct cell type
    func returnACorrectCell(index: IndexPath) -> Bool {
        if (index.row == output!.screenData![index.section].data.count){
            return true
        }
        else
        {
            return false
        }
    }
    //MARK: Data for cell
    func returnDataForCell(data: Row) -> (String, String, String){
        var ingredients = data.ingredients ?? ""
        if ingredients == "()" {
            ingredients = ""
        }
        return (data.mealName, ingredients, data.price ?? "")
    }
    //MARK: AllowsPress
    func canPress(index: IndexPath) -> Bool {
        if index.row == output!.screenData![index.section].data.count {
            return false
        }
        else
        {
            return true
        }
        
    }
    //MARK: Total amount
    func returnTotalAmount(data: [Row]) -> Int {
        var total: Int = 0
        for meal in data{
            total = total + (Int(meal.price!) ?? 0)
        }
        return total
    }
    //MARK: Number of cells
    func returnNumberOfCells(section: Int) -> Int {
        if (output?.screenData?[section].data.count) ?? 0 == 0 {
            return 0
        }
        else {
            return output!.screenData![section].data.count + 1
        }
    }
    //MARK: Setup Screen data
    func setupScreenData(data: [MealsWithRestoraunt]) -> [Section]{
        var restoraunts = [Section]()
        for restoraunt in data {
            if restoraunts.count == 0 {
                restoraunts.append(Section(restorauntName: restoraunt.restorauntName, mob: restoraunt.mobLabel ?? "", tel: restoraunt.telLabel ?? "", data: [Row]()))
            }
            else {
                var savedRestoraunt: Bool = false
                for saved in restoraunts {
                    if saved.restorauntName == restoraunt.restorauntName {
                        savedRestoraunt = true
                    }
                }
                if !savedRestoraunt {
                    restoraunts.append(Section(restorauntName: restoraunt.restorauntName, mob: restoraunt.mobLabel ?? "", tel: restoraunt.telLabel ?? "", data: [Row]()))
                }
            }
        }
        
        for meal in data {
            for (n, saved) in restoraunts.enumerated() {
                if meal.restorauntName == saved.restorauntName {
                    restoraunts[n].data.append(Row(mealName: meal.name, ingredients: returnIngredients(data: meal), price: meal.price ?? ""))
                }
            }
        }
        
        return restoraunts
    }
    //MARK: Ingredients
    func returnIngredients(data: MealsWithRestoraunt) -> String{
        var ingredients: String = ""
        if data.ingredients?.count ?? 0 > 0 {
            ingredients = ""
            for ingredient in data.ingredients! {
                if ingredients != "" {
                    ingredients = ingredients + ", " + ingredient.name!
                }
                else {
                    ingredients = ingredient.name!
                }
            }
        }
        return ingredients
    }
}
