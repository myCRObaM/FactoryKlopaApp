//
//  WishListControllerTests.swift
//  WishListTests
//
//  Created by Matej Hetzel on 28/11/2019.
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

class WishListControllerTests: QuickSpec {
        override func spec() {
            describe("setup Data"){
                var testScheduler: TestScheduler!
                var mealsData: [MealsWithRestoraunt]!
                let disposeBag = DisposeBag()
                let mockedRepo = MockDataRepo()
                var restorauntsViewModel: WishListViewModel!
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
                }
            }
    }

}
