//
//  RestorauntMealTypesModelTests.swift
//  MealsScreenTests
//
//  Created by Matej Hetzel on 14/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import XCTest
import RxTest
import RxSwift
import Nimble
import Quick
import Cuckoo
import Shared
@testable import MealsScreen

class RestorauntMealTypesModelTests: QuickSpec {
    override func spec() {
        describe("setup Data"){
            var testScheduler: TestScheduler!
            var restorauntsData: [Restoraunts]!
            var mealCategories: [MealCategory]!
            let disposeBag = DisposeBag()
            let mockedRepo = MockDataRepo()
            var restorauntsViewModel: RestorauntMealTypesModel!
            beforeSuite {
                Cuckoo.stub(mockedRepo) { mock in
                    let testBundle = Bundle(for: RestorauntMealTypesModelTests.self)
                    guard let path = testBundle.url(forResource: "JSONtests", withExtension: "json") else {return}
                    let dataFromLocation = try! Data(contentsOf: path)
                    let restoraunts = try! JSONDecoder().decode([RestorauntsModel].self, from: dataFromLocation)
                    let convertToStruct = ConvertToStruct()
                    restorauntsData = convertToStruct.convertToStruct(restoraunts: restoraunts)
                }
            }
            context("initialize view Model"){
                beforeEach {
                    testScheduler = TestScheduler(initialClock: 0)
                    mealCategories = self.arrayOfCategorySortedMeals(restorants: restorauntsData)
                    restorauntsViewModel = RestorauntMealTypesModel(dependencies: RestorauntMealTypesModel.Dependencies(scheduler: testScheduler, mealCategory: mealCategories[1]))
                    
                    let output = restorauntsViewModel.transform(input: RestorauntMealTypesModel.Input(getData: ReplaySubject<Bool>.create(bufferSize: 1)))
                    
                    for disposable in output.disposables {
                        disposable.disposed(by: disposeBag)
                    }
                    
                }
                it("check if function is returning good value"){
                    testScheduler.start()
                    
                    let margarite = restorauntsViewModel.didSelectRow(mealWithName: mealCategories[1].meals, name: "Margarita")
                    expect(margarite.count).toEventually(equal(7))
                    expect(margarite[0].name).toEventually(equal("Margarita"))
                    expect(margarite[0].restorauntName).toEventually(equal("Dadorely"))
                    expect(margarite[1].restorauntName).toEventually(equal("Petar Pan"))
                    expect(margarite[2].restorauntName).toEventually(equal("Fast food Njam-njam"))
                    expect(margarite[3].restorauntName).toEventually(equal("Asterix"))
                    expect(margarite[4].restorauntName).toEventually(equal("Fast food Marleo"))
                    expect(margarite[5].restorauntName).toEventually(equal("Pizzeria 4M"))
                    expect(margarite[6].restorauntName).toEventually(equal("Sandwich bar Dennis"))
                }
                
                it("check if function is returning good string value"){
                    testScheduler.start()
                    expect(restorauntsViewModel.returnLabelData(meal: mealCategories[0])).toEventually(equal("mealType_Desert"))
                    expect(restorauntsViewModel.returnLabelData(meal: mealCategories[1])).toEventually(equal("mealType_Pizza"))
                    expect(restorauntsViewModel.returnLabelData(meal: mealCategories[2])).toEventually(equal("mealType_Salad"))
                    expect(restorauntsViewModel.returnLabelData(meal: mealCategories[3])).toEventually(equal("mealType_Pasta"))
                    expect(restorauntsViewModel.returnLabelData(meal: mealCategories[4])).toEventually(equal("mealType_Hamburger"))
                    expect(restorauntsViewModel.returnLabelData(meal: mealCategories[5])).toEventually(equal("mealType_GM"))
                    expect(restorauntsViewModel.returnLabelData(meal: mealCategories[6])).toEventually(equal("mealType_Ostalo"))
                }
            }
        }
    }
    
    
    func arrayOfCategorySortedMeals(restorants: [Restoraunts]) -> [MealCategory] {
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
}
