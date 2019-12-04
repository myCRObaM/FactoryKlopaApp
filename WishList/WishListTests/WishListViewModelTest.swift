//
//  WishListViewModelTest.swift
//  WishListTests
//
//  Created by Matej Hetzel on 04/12/2019.
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
@testable import WishList

class WishListViewModelTest: QuickSpec {
    override func spec() {
        describe("setup Data"){
            var testScheduler: TestScheduler!
            var mealsData: [MealsWithRestoraunt]!
            var screenData: [Section]!
            let disposeBag = DisposeBag()
            var viewModel: WishListViewModel!
            beforeSuite {
                mealsData = self.createData()
                
            }
            context("initialize view Model"){
                var dataReadySubject: TestableObserver<Bool>!
                beforeEach {
                    testScheduler = TestScheduler(initialClock: 0)
                    viewModel = WishListViewModel(dependencies: WishListViewModel.Dependencies(scheduler: testScheduler, realmRepo: RealmManager()))
                    
                    let output = viewModel.transform(input: WishListViewModel.Input(getData: ReplaySubject<Bool>.create(bufferSize: 1), deleteMeal: PublishSubject<IndexPath>()))
                    
                    for disposable in output.disposables {
                        disposable.disposed(by: disposeBag)
                    }
                    screenData = viewModel.setupScreenData(data: mealsData)
                    dataReadySubject = testScheduler.createObserver(Bool.self)
                    viewModel.output.dataReady.subscribe(dataReadySubject).disposed(by: disposeBag)
                }
                it("Check the setupScreen data function"){
                    testScheduler.start()
                    
                    let data = viewModel.setupScreenData(data: mealsData)
                    expect(data.count).toEventually(equal(7))
                    expect(data[0].data.count).toEventually(equal(1))
                    expect(data[0].restorauntName).toEventually(equal("Dadorely"))
                }
                it("Check if function for header data is returning correct data"){
                    testScheduler.start()
                    
                    let data = viewModel.dataForHeader(data: screenData[0])
                    
                    expect(data.mText).toEventually(equal("Mob: 097 673 2130"))
                    expect(data.price).toEventually(equal("price"))
                    expect(data.rName).toEventually(equal("Dadorely"))
                    expect(data.tText).toEventually(equal("Tel: 033 732 130"))
                }
                it("Check if function for cell data is returning correct data"){
                    testScheduler.start()
                    
                    let data = viewModel.returnDataForCell(data: screenData[0].data[0])
                    
                    expect(data.mealName).toEventually(equal("Margarita"))
                    expect(data.ingredients).toEventually(equal("rajcica, sir"))
                    expect(data.price).toEventually(equal("25"))
                }
                it("Return total amount for a cell"){
                    testScheduler.start()
                    
                    expect(viewModel.returnTotalAmount(data: screenData[0].data)).toEventually(equal(25))
                    expect(viewModel.returnTotalAmount(data: screenData[1].data)).toEventually(equal(25))
                    expect(viewModel.returnTotalAmount(data: screenData[2].data)).toEventually(equal(25))
                    expect(viewModel.returnTotalAmount(data: screenData[3].data)).toEventually(equal(22))
                    expect(viewModel.returnTotalAmount(data: screenData[4].data)).toEventually(equal(30))
                    expect(viewModel.returnTotalAmount(data: screenData[5].data)).toEventually(equal(25))
                }
                
                it("return number of cells"){
                    testScheduler.start()
                    
                    expect(viewModel.returnNumberOfCells(section: screenData[0])).toEventually(equal(2))
                    expect(viewModel.returnNumberOfCells(section: screenData[1])).toEventually(equal(2))
                    expect(viewModel.returnNumberOfCells(section: screenData[2])).toEventually(equal(2))
                    expect(viewModel.returnNumberOfCells(section: screenData[3])).toEventually(equal(2))
                    expect(viewModel.returnNumberOfCells(section: screenData[4])).toEventually(equal(2))
                    expect(viewModel.returnNumberOfCells(section: screenData[5])).toEventually(equal(2))
                }
                it("Check ingredients function"){
                    testScheduler.start()
                    
                    expect(viewModel.returnIngredients(data: mealsData[0])).toEventually(equal("rajcica, sir"))
                    expect(viewModel.returnIngredients(data: mealsData[1])).toEventually(equal("rajcica, sir"))
                    expect(viewModel.returnIngredients(data: mealsData[2])).toEventually(equal("rajcica, sir, maslina"))
                    expect(viewModel.returnIngredients(data: mealsData[3])).toEventually(equal("rajcica, sir"))
                }
                
            }
        }
    }
    
    
    func createData() -> [MealsWithRestoraunt]{
        return [Shared.MealsWithRestoraunt(name: "Margarita", priceNormal: Optional("25"), priceJumbo: nil, price: Optional("25"), ingredients: Optional([Shared.Ingredients(name: Optional("rajcica")), Shared.Ingredients(name: Optional("sir"))]), restorauntName: "Dadorely", mobLabel: Optional("097 673 2130"), telLabel: Optional("033 732 130")), Shared.MealsWithRestoraunt(name: "Margarita", priceNormal: Optional("25"), priceJumbo: Optional("50"), price: Optional("25"), ingredients: Optional([Shared.Ingredients(name: Optional("rajcica")), Shared.Ingredients(name: Optional("sir"))]), restorauntName: "Petar Pan", mobLabel: Optional(""), telLabel: Optional("033 727 888")), Shared.MealsWithRestoraunt(name: "Margarita", priceNormal: Optional("25"), priceJumbo: Optional("45"), price: Optional("25"), ingredients: Optional([Shared.Ingredients(name: Optional("rajcica")), Shared.Ingredients(name: Optional("sir")), Shared.Ingredients(name: Optional("maslina"))]), restorauntName: "Fast food Njam-njam", mobLabel: Optional("099 757 9022"), telLabel: Optional("033 722 299")), Shared.MealsWithRestoraunt(name: "Margarita", priceNormal: Optional("22"), priceJumbo: Optional("44"), price: Optional("22"), ingredients: Optional([Shared.Ingredients(name: Optional("rajcica")), Shared.Ingredients(name: Optional("sir"))]), restorauntName: "Asterix", mobLabel: Optional("092 319 7077"), telLabel: Optional("033 800 103")), Shared.MealsWithRestoraunt(name: "Margarita", priceNormal: Optional("30"), priceJumbo: nil, price: Optional("30"), ingredients: Optional([Shared.Ingredients(name: Optional("rajcica")), Shared.Ingredients(name: Optional("sir")), Shared.Ingredients(name: Optional("tijesto"))]), restorauntName: "Fast food Marleo", mobLabel: Optional(""), telLabel: Optional("033 725 010")), Shared.MealsWithRestoraunt(name: "Margarita", priceNormal: Optional("25"), priceJumbo: Optional("50"), price: Optional("25"), ingredients: Optional([Shared.Ingredients(name: Optional("rajcica")), Shared.Ingredients(name: Optional("sir"))]), restorauntName: "Pizzeria 4M", mobLabel: Optional(""), telLabel: Optional("033 728 326")), Shared.MealsWithRestoraunt(name: "Margarita", priceNormal: Optional("25"), priceJumbo: Optional("50"), price: Optional("25"), ingredients: Optional([Shared.Ingredients(name: Optional("rajcica")), Shared.Ingredients(name: Optional("sir")), Shared.Ingredients(name: Optional("maslina"))]), restorauntName: "Sandwich bar Dennis", mobLabel: Optional("098 725 432"), telLabel: Optional("033 725 432"))]
    }
}

