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

class RestorauntsViewModel {
    //MARK: Define structs
    struct Input {
        var getDataSubject: ReplaySubject<Bool>
    }
    
    struct Output {
        var dataIsDoneSubject: ReplaySubject<Bool>
        var errorSubject: PublishSubject<Bool>
        var disposables: [Disposable]
    }
    
    struct Dependencies {
        var scheduler: SchedulerType
        var repo: DataRepo
    }
    
    //MARK: Variables
    let dependencies: Dependencies
    var input: Input!
    var output: Output!
    var restoraunts = [Restoraunts]()
    
    //MARK: Init
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    //MARK: Transfrom
    func transform(input: RestorauntsViewModel.Input) -> RestorauntsViewModel.Output {
        self.input = input
        var disposables = [Disposable]()
        
        disposables.append(getData(subject: input.getDataSubject))
        
        self.output = Output(dataIsDoneSubject: ReplaySubject<Bool>.create(bufferSize: 1), errorSubject: PublishSubject(), disposables: disposables)
        return output
    }
    
    
    func getData(subject: ReplaySubject<Bool>) -> Disposable {
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
    func convertToStruct(restoraunts: [RestorauntsModel]) -> [Restoraunts] {
        let convertClass = ConvertToStruct()
        return convertClass.convertToStruct(restoraunts: restoraunts)
    }
    
    //MARK: return Cell data
      func returnCellData(type: MealTypes) -> (String, URL) {
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
    
    func arrayOfCategorySortedMeals(restorants: [Restoraunts]) -> [MealTypes] {
        var array = [MealTypes]()
        var didAdd: Bool = false
        for restoratunt in restorants {
            for mealType in restoratunt.meals{
                for (n, arrayMealType) in array.enumerated() {
                    if mealType.type == arrayMealType.type {
                        array[n].meals.append(contentsOf: mealType.meals)
                        didAdd = true
                    }
                }
                if !didAdd {
                    array.append(mealType)
                }
                didAdd = false
            }
        }
        return array
    }
}
