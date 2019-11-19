//
//  MealsModelTests.swift
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
@testable import RestorauntsSingle

class RestorauntsSingleModelTests: QuickSpec {
    override func spec() {
        describe("setup Data"){
            var mealsViewModel: RestorauntsSingleModel!
            var testScheduler: TestScheduler!
            var restorauntsData: [Restoraunts]!
            let disposeBag = DisposeBag()
            let mockedRepo = MockDataRepo()
            beforeSuite {
                Cuckoo.stub(mockedRepo) { mock in
                    let testBundle = Bundle(for: RestorauntsSingleModelTests.self)
                    guard let path = testBundle.url(forResource: "JSONtests", withExtension: "json") else {return}
                    let dataFromLocation = try! Data(contentsOf: path)
                    let restoraunts = try! JSONDecoder().decode([RestorauntsModel].self, from: dataFromLocation)
                    let convertToStruct = ConvertToStruct()
                    restorauntsData = convertToStruct.convertToStruct(restoraunts: restoraunts)
                }
            }
            context("initialize viewModel"){
                var dataReadySubject: TestableObserver<Bool>!
                var expandableHandler: TestableObserver<ExpansionEnum>!
                beforeEach {
                    testScheduler = TestScheduler(initialClock: 0)
                    
                    mealsViewModel = RestorauntsSingleModel(dependencies: RestorauntsSingleModel.Dependencies(scheduler: testScheduler, meals: restorauntsData[0]))
                    
                    let output = mealsViewModel.transform(input: RestorauntsSingleModel.Input(loadScreenData: ReplaySubject<Bool>.create(bufferSize: 1)))
                    
                    for disposable in output.disposables{
                        disposable.disposed(by: disposeBag)
                    }
                    
                    dataReadySubject = testScheduler.createObserver(Bool.self)
                                   mealsViewModel.output.dataReady.subscribe(dataReadySubject).disposed(by: disposeBag)
                    expandableHandler = testScheduler.createObserver(ExpansionEnum.self)
                                                      mealsViewModel.output.expandableHandler.subscribe(expandableHandler).disposed(by: disposeBag)
                }
                it("check if data is loaded correctly"){
                    testScheduler.start()
                    mealsViewModel.input.loadScreenData.onNext(true)
                    
                    expect(dataReadySubject.events[0].value.element).toEventually(equal(true))
                }
                it("check if function is returning good values for header"){
                    testScheduler.start()
                    
                    expect(mealsViewModel.returnHeaderName(meal: restorauntsData[1].meals[0])).toEventually(equal("Desert"))
                    expect(mealsViewModel.returnHeaderName(meal: restorauntsData[1].meals[1])).toEventually(equal("Pizza"))
                    expect(mealsViewModel.returnHeaderName(meal: restorauntsData[1].meals[2])).toEventually(equal("Salata"))
                }
                it("check if number of rows function is returning a good value dependent on isCollapsed parameter"){
                    testScheduler.start()
                    
                    mealsViewModel.dependencies.meals.meals[0].isCollapsed = false
                    mealsViewModel.dependencies.meals.meals[1].isCollapsed = false
                    
                    expect(mealsViewModel.numberOfRows(section: 0)).toEventually(equal(1))
                    expect(mealsViewModel.numberOfRows(section: 1)).toEventually(equal(44))
                }
                it("check is pizza function"){
                    testScheduler.start()
                    
                    expect(mealsViewModel.isPizza(category: "ne")).toEventually(equal(false))
                    expect(mealsViewModel.isPizza(category: "Pizza")).toEventually(equal(true))
                }
                it("check if collapsed checker is good"){
                    testScheduler.start()
                    
                    mealsViewModel.dependencies.meals.meals[0].isCollapsed = false
                    
                    expect(mealsViewModel.isButtonSelected(section: 0)).toEventually(equal(true))
                    expect(mealsViewModel.isButtonSelected(section: 1)).toEventually(equal(false))
                }
            }
        }
    }
    
}