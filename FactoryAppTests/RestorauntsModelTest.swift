//
//  RestorauntsModelTest.swift
//  SharedTests
//
//  Created by Matej Hetzel on 21/11/2019.
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
@testable import FactoryApp

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
                    
                    let output = restorauntsViewModel.transform(input: RestorauntsViewModel.Input(getDataSubject: ReplaySubject<Bool>.create(bufferSize: 1), screenSelectionSubject: PublishSubject<Bool>()))
                    
                    for disposable in output.disposables {
                        disposable.disposed(by: disposeBag)
                    }
                    
                }
                it("check if data is correctly loaded and converted"){
                    testScheduler.start()
                    
                    restorauntsViewModel.input.getDataSubject.onNext(true)
                    expect(restorauntsViewModel.restoraunts.count).toEventually(equal(restorauntsData.count))
                    expect(restorauntsViewModel.restoraunts[0].name).toEventually(equal(restorauntsData[0].name))
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
                it("check if function is returning good cell data"){
                    testScheduler.start()
                    
                    let data = restorauntsViewModel.arrayOfCategorySortedMeals(restorants: restorauntsData)
                    
                    expect(restorauntsViewModel.returnCellData(type: data[0]).0).toEventually(equal("Deserti"))
                    expect(restorauntsViewModel.returnCellData(type: data[1]).0).toEventually(equal("Pizze"))
                    expect(restorauntsViewModel.returnCellData(type: data[2]).0).toEventually(equal("Salate"))
                    expect(restorauntsViewModel.returnCellData(type: data[3]).0).toEventually(equal("Tjestenina"))
                    expect(restorauntsViewModel.returnCellData(type: data[4]).0).toEventually(equal("Hamburgeri"))
                    expect(restorauntsViewModel.returnCellData(type: data[5]).0).toEventually(equal("GrillMeals"))
                    expect(restorauntsViewModel.returnCellData(type: data[6]).0).toEventually(equal("Ostalo"))
                    expect(restorauntsViewModel.returnCellData(type: data[7]).0).toEventually(equal("Prilozi"))
                    expect(restorauntsViewModel.returnCellData(type: data[8]).0).toEventually(equal("Sendvici"))
                    expect(restorauntsViewModel.returnCellData(type: data[9]).0).toEventually(equal("Kebab"))
                    expect(restorauntsViewModel.returnCellData(type: data[10]).0).toEventually(equal("Riblja jela"))
                    expect(restorauntsViewModel.returnCellData(type: data[11]).0).toEventually(equal("Dodatci"))
                }
            }
        }
    }
}
