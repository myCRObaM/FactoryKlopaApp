//
//  RestorauntsModelTests.swift
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

class RestorauntsModelTests: QuickSpec {
    override func spec() {
        describe("setup Data"){
            var restorauntsViewModel: RestorauntsViewModel!
            var testScheduler: TestScheduler!
            var restorauntsData: [Restoraunts]!
            let disposeBag = DisposeBag()
            let mockedRepo = MockDataRepo()
            beforeSuite {
                Cuckoo.stub(mockedRepo) { mock in
                let testBundle = Bundle(for: RestorauntsModelTests.self)
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
                    
                    restorauntsViewModel = RestorauntsViewModel(dependencies: RestorauntsViewModel.Dependencies(scheduler: testScheduler, repo: DataRepo()))
                    
                    let output = restorauntsViewModel.transform(input: RestorauntsViewModel.Input(getDataSubject: ReplaySubject<Bool>.create(bufferSize: 1)))
                    
                    for disposable in output.disposables {
                        disposable.disposed(by: disposeBag)
                    }
                    
                }
                it("check if data is correctly loaded and converted"){
                    testScheduler.start()
                    
                    restorauntsViewModel.input.getDataSubject.onNext(true)
                    expect(restorauntsViewModel.restoraunts.count).toEventually(equal(restorauntsData.count))
                }
                it("check if data is correctly sorted into categories"){
                    testScheduler.start()
                    
                    let sorted = restorauntsViewModel.arrayOfCategorySortedMeals(restorants: restorauntsData)
                    
                    expect(sorted.count).toEventually(equal(12))
                    expect(sorted[0].type).toEventually(equal(.desert))
                    expect(sorted[1].type).toEventually(equal(.pizza))
                    expect(sorted[2].type).toEventually(equal(.salad))
                    expect(sorted[3].type).toEventually(equal(.pasta))
                    expect(sorted[4].type).toEventually(equal(.hamburgers))
                    expect(sorted[5].type).toEventually(equal(.grillMeals))
                    expect(sorted[6].type).toEventually(equal(.other))
                    expect(sorted[7].type).toEventually(equal(.side))
                    
                    expect(sorted[0].meals.count).toEventually(equal(6))
                    expect(sorted[1].meals.count).toEventually(equal(197))
                    expect(sorted[2].meals.count).toEventually(equal(30))
                    expect(sorted[3].meals.count).toEventually(equal(18))
                    expect(sorted[4].meals.count).toEventually(equal(5))
                    expect(sorted[5].meals.count).toEventually(equal(22))
                    expect(sorted[6].meals.count).toEventually(equal(10))
                    expect(sorted[7].meals.count).toEventually(equal(19))
                    
                }
            }
        }
    }
}
