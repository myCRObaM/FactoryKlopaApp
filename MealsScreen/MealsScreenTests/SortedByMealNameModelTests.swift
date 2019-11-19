//
//  SortedByMealNameModelTests.swift
//  MealsScreenTests
//
//  Created by Matej Hetzel on 19/11/2019.
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

class SortedByMealNameModelTests: QuickSpec {
    override func spec() {
        describe("setup Data"){
            var testScheduler: TestScheduler!
            var sortByMeals: [MealsWithRestoraunt]!
            let disposeBag = DisposeBag()
            var sortedByViewModel: SortedByMealNameModel!
            beforeSuite {
                sortByMeals = self.createData()
            }
            context("initialize view Model"){
                var dataReadySubject: TestableObserver<Bool>!
                beforeEach {
                    testScheduler = TestScheduler(initialClock: 0)
                    sortedByViewModel = SortedByMealNameModel(dependencies: SortedByMealNameModel.Dependencies(meals: sortByMeals, scheduler: testScheduler))
                    
                    let output = sortedByViewModel.transform(input: SortedByMealNameModel.Input(getData: ReplaySubject<Bool>.create(bufferSize: 1)))
                    
                    for disposable in output.disposables {
                        disposable.disposed(by: disposeBag)
                    }
                    
                    dataReadySubject = testScheduler.createObserver(Bool.self)
                    sortedByViewModel.output.dataReady.subscribe(dataReadySubject).disposed(by: disposeBag)
                }
                it("check if subject is triggered"){
                    testScheduler.start()
                    
                    sortedByViewModel.input.getData.onNext(true)
                    expect(dataReadySubject.events[0].value.element).toEventually(equal(true))
                    expect(dataReadySubject.events.count).toEventually(equal(1))
                }
            }
        }
    }
    
    
    func createData() -> [MealsWithRestoraunt]{
        return [Shared.MealsWithRestoraunt(name: "Margarita", priceNormal: Optional("25"), priceJumbo: nil, price: Optional("25"), ingredients: Optional([Shared.Ingredients(name: Optional("rajcica")), Shared.Ingredients(name: Optional("sir"))]), restorauntName: "Dadorely", mobLabel: Optional("097 673 2130"), telLabel: Optional("033 732 130")), Shared.MealsWithRestoraunt(name: "Margarita", priceNormal: Optional("25"), priceJumbo: Optional("50"), price: Optional("25"), ingredients: Optional([Shared.Ingredients(name: Optional("rajcica")), Shared.Ingredients(name: Optional("sir"))]), restorauntName: "Petar Pan", mobLabel: Optional(""), telLabel: Optional("033 727 888")), Shared.MealsWithRestoraunt(name: "Margarita", priceNormal: Optional("25"), priceJumbo: Optional("45"), price: Optional("25"), ingredients: Optional([Shared.Ingredients(name: Optional("rajcica")), Shared.Ingredients(name: Optional("sir")), Shared.Ingredients(name: Optional("maslina"))]), restorauntName: "Fast food Njam-njam", mobLabel: Optional("099 757 9022"), telLabel: Optional("033 722 299")), Shared.MealsWithRestoraunt(name: "Margarita", priceNormal: Optional("22"), priceJumbo: Optional("44"), price: Optional("22"), ingredients: Optional([Shared.Ingredients(name: Optional("rajcica")), Shared.Ingredients(name: Optional("sir"))]), restorauntName: "Asterix", mobLabel: Optional("092 319 7077"), telLabel: Optional("033 800 103")), Shared.MealsWithRestoraunt(name: "Margarita", priceNormal: Optional("30"), priceJumbo: nil, price: Optional("30"), ingredients: Optional([Shared.Ingredients(name: Optional("rajcica")), Shared.Ingredients(name: Optional("sir")), Shared.Ingredients(name: Optional("tijesto"))]), restorauntName: "Fast food Marleo", mobLabel: Optional(""), telLabel: Optional("033 725 010")), Shared.MealsWithRestoraunt(name: "Margarita", priceNormal: Optional("25"), priceJumbo: Optional("50"), price: Optional("25"), ingredients: Optional([Shared.Ingredients(name: Optional("rajcica")), Shared.Ingredients(name: Optional("sir"))]), restorauntName: "Pizzeria 4M", mobLabel: Optional(""), telLabel: Optional("033 728 326")), Shared.MealsWithRestoraunt(name: "Margarita", priceNormal: Optional("25"), priceJumbo: Optional("50"), price: Optional("25"), ingredients: Optional([Shared.Ingredients(name: Optional("rajcica")), Shared.Ingredients(name: Optional("sir")), Shared.Ingredients(name: Optional("maslina"))]), restorauntName: "Sandwich bar Dennis", mobLabel: Optional("098 725 432"), telLabel: Optional("033 725 432"))]
    }
}
