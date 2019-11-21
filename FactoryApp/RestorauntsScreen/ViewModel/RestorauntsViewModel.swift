//
//  RestorauntsViewModel.swift
//  NewOrderScreen
//
//  Created by Matej Hetzel on 28/10/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import RxSwift
import Shared

public class RestorauntsViewModel {
    //MARK: Define structs
    public struct Input {
        public var getDataSubject: ReplaySubject<Bool>
        
        public init(getDataSubject: ReplaySubject<Bool>){
            self.getDataSubject = getDataSubject
        }
    }
    
    public struct Output {
        public var dataIsDoneSubject: ReplaySubject<Bool>
        public var errorSubject: PublishSubject<Bool>
        public var disposables: [Disposable]
        
        public init(dataIsDoneSubject: ReplaySubject<Bool>, errorSubject: PublishSubject<Bool>, disposables: [Disposable]){
            self.dataIsDoneSubject = dataIsDoneSubject
            self.errorSubject = errorSubject
            self.disposables = disposables
        }
    }
    
    public struct Dependencies {
        public var scheduler: SchedulerType
        public var repo: DataRepo
        
        public init(scheduler: SchedulerType, repo: DataRepo){
            self.scheduler = scheduler
            self.repo = repo
        }
    }
    
    //MARK: Variables
    public let dependencies: Dependencies
    public var input: Input!
    public var output: Output!
    public var restoraunts = [Restoraunts]()
    
    //MARK: Init
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    //MARK: Transfrom
    public func transform(input: RestorauntsViewModel.Input) -> RestorauntsViewModel.Output {
        self.input = input
        var disposables = [Disposable]()
        
        disposables.append(getData(subject: input.getDataSubject))
        
        self.output = Output(dataIsDoneSubject: ReplaySubject<Bool>.create(bufferSize: 1), errorSubject: PublishSubject(), disposables: disposables)
        return output
    }
    
    
    public func getData(subject: ReplaySubject<Bool>) -> Disposable {
         return subject
         .flatMap({ [unowned self] bool -> Observable<[RestorauntsModel]> in
             return self.dependencies.repo.getData()
             })
         .observeOn(MainScheduler.instance)
         .subscribeOn(dependencies.scheduler)
         .subscribe(onNext: { [unowned self] bool in
            self.restoraunts = self.convertToStruct(restoraunts: bool)
            self.output.dataIsDoneSubject.onNext(true)
            
         }, onError: {[unowned self] bool in
                 self.output.errorSubject.onNext(true)
         })
    }
    
    //MARK: Model to Data functions
    public func convertToStruct(restoraunts: [RestorauntsModel]) -> [Restoraunts] {
        let convertClass = ConvertToStruct()
        return convertClass.convertToStruct(restoraunts: restoraunts)
    }
    
    //MARK: return Cell data
      public func returnCellData(type: MealCategory) -> (String, URL) {
        switch type.type {
          case .additions:
              return ("Dodatci", URL(string: "http://klopa.factory.hr/wp-content/uploads/2019/02/lazanje.jpg")!)
          case .desert:
              return ("Deserti", URL(string: "http://klopa.factory.hr/wp-content/uploads/2019/02/deserti.jpg")!)
          case .hamburgers:
              return ("Hamburgeri", URL(string: "http://klopa.factory.hr/wp-content/uploads/2019/02/hamburgeri.jpg")!)
          case .mealsByOrder:
              return ("Jela po narudbi", URL(string: "http://klopa.factory.hr/wp-content/uploads/2019/02/jela-po-narudzbi.jpg")!)
          case .grillMeals:
              return ("GrillMeals", URL(string: "http://klopa.factory.hr/wp-content/uploads/2019/02/jela-s-rostilja.jpg")!)
          case .kebab:
              return ("Kebab", URL(string: "http://klopa.factory.hr/wp-content/uploads/2019/02/kebab.jpg")!)
          case .other:
              return ("Ostalo", URL(string: "http://klopa.factory.hr/wp-content/uploads/2019/03/Ostalo.jpg")!)
          case .pizza:
              return ("Pizze", URL(string: "http://klopa.factory.hr/wp-content/uploads/2019/02/pizze.jpg")!)
          case .side:
              return ("Prilozi", URL(string: "http://klopa.factory.hr/wp-content/uploads/2019/02/prilozi.jpg")!)
          case .fishMeals:
              return ("Riblja jela", URL(string: "http://klopa.factory.hr/wp-content/uploads/2019/02/riblja-jela.jpg")!)
          case .riceMeals:
              return ("Rizoto", URL(string: "http://klopa.factory.hr/wp-content/uploads/2019/02/rizoto.jpg")!)
          case .salad:
              return ("Salate", URL(string: "http://klopa.factory.hr/wp-content/uploads/2019/02/salate.jpg")!)
          case .sendwich:
              return ("Sendvici", URL(string: "http://klopa.factory.hr/wp-content/uploads/2019/02/sendvici.jpg")!)
          case .pasta:
              return ("Tjestenina", URL(string: "http://klopa.factory.hr/wp-content/uploads/2019/02/tjestenine.jpg")!)
          }
      }
    
    public func arrayOfCategorySortedMeals(restorants: [Restoraunts]) -> [MealCategory] {
        var array = [MealCategory]()
        var meals = [MealsWithRestoraunt]()
        var didAdd: Bool = false
        for restoratunt in restorants {
            for mealType in restoratunt.meals{
                for individualMeal in mealType.meals {
                    meals.append(MealsWithRestoraunt(name: individualMeal.name, priceNormal: individualMeal.priceNormal, priceJumbo: individualMeal.priceJumbo, price: individualMeal.price, ingredients: individualMeal.ingredients, restorauntName: restoratunt.name, mobLabel: restoratunt.mob, telLabel: restoratunt.tel))
                }
                for (n, arrayMealType) in array.enumerated() {
                    if mealType.type == arrayMealType.type {
                        if mealType.type == .pizza {
                            meals[0].isPizza = true
                        }
                        array[n].meals.append(contentsOf: meals)
                        didAdd = true
                    }
                }
                if !didAdd {
                    array.append(MealCategory(type: mealType.type, meals: meals))
                }
                didAdd = false
                meals.removeAll()
            }
        }
        return array
    }
    
    func restorauntsButtonIsSelected(bool: Bool) -> (Bool, Bool){
        var isSelected: Bool = true
        if bool{
            isSelected = true
        }
        else {
            isSelected = false
        }
        return (isSelected, !isSelected)
    }
}
