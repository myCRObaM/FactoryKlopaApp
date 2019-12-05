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
            var screenData: RestorauntsSingleScreenStruct!
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
                var saveMealSubject: TestableObserver<SaveToListEnum>!
                var expandButton: TestableObserver<Bool>!
                beforeEach {
                    testScheduler = TestScheduler(initialClock: 0)
                    
                    mealsViewModel = RestorauntsSingleModel(dependencies: RestorauntsSingleModel.Dependencies(scheduler: testScheduler, meals: restorauntsData[0], realmManager: RealmManager()))
                    
                    let output = mealsViewModel.transform(input: RestorauntsSingleModel.Input(loadScreenData: ReplaySubject<Bool>.create(bufferSize: 1), saveMeal: PublishSubject<SaveToListEnum>(), screenSelectionButtonSubject: PublishSubject<Bool>(), expandButtonStateSubject: ReplaySubject<Section>.create(bufferSize: 1)))
                    
                    for disposable in output.disposables{
                        disposable.disposed(by: disposeBag)
                    }
                    
                    screenData = mealsViewModel.setupScreenData(data: restorauntsData[1])
                    
                    dataReadySubject = testScheduler.createObserver(Bool.self)
                                   mealsViewModel.output.dataReady.subscribe(dataReadySubject).disposed(by: disposeBag)
                    expandableHandler = testScheduler.createObserver(ExpansionEnum.self)
                                    mealsViewModel.output.expandableHandler.subscribe(expandableHandler).disposed(by: disposeBag)
                    saveMealSubject = testScheduler.createObserver(SaveToListEnum.self)
                                    mealsViewModel.input.saveMeal.subscribe(saveMealSubject).disposed(by: disposeBag)
                    expandButton = testScheduler.createObserver(Bool.self)
                                    mealsViewModel.output.expandButtonStateSubject.subscribe(expandButton).disposed(by: disposeBag)
                }
                it("check if data is loaded correctly"){
                    testScheduler.start()
                    mealsViewModel.input.loadScreenData.onNext(true)
                    
                    expect(dataReadySubject.events[0].value.element).toEventually(equal(true))
                }
                it("check if setupScreenData function is working correctly"){
                    testScheduler.start()
                    
                    expect(mealsViewModel.setupScreenData(data: restorauntsData[0]).section.count).toEventually(equal(2))
                    expect(mealsViewModel.setupScreenData(data: restorauntsData[0]).workingHours).toEventually(equal("Ponedjeljak - Subota od 8:00 - 22.30"))
                    expect(mealsViewModel.setupScreenData(data: restorauntsData[0]).title).toEventually(equal("Dadorely"))
                    expect(mealsViewModel.setupScreenData(data: restorauntsData[0]).mob).toEventually(equal("097 673 2130"))
                }
                it("check has jumbo price function"){
                    testScheduler.start()
                    
                    expect(mealsViewModel.hasJumboPrice(price: "2")).toEventually(equal(true))
                    expect(mealsViewModel.hasJumboPrice(price: "")).toEventually(equal(false))
                }
                
                it("check if function is returning good values for header"){
                    testScheduler.start()
                    
                    expect(mealsViewModel.returnHeaderName(meal: restorauntsData[1].meals[0].type)).toEventually(equal("Desert"))
                    expect(mealsViewModel.returnHeaderName(meal: restorauntsData[1].meals[1].type)).toEventually(equal("Pizza"))
                    expect(mealsViewModel.returnHeaderName(meal: restorauntsData[1].meals[2].type)).toEventually(equal("Salata"))
                }
                it("check is pizza function"){
                    testScheduler.start()
                    
                    screenData.section[1].isCollapsed = false
                    expect(mealsViewModel.isPizza(category: screenData.section[0])).toEventually(equal(false))
                    expect(mealsViewModel.isPizza(category: screenData.section[1])).toEventually(equal(true))
                }
                it("check if collapsed checker is good"){
                    testScheduler.start()
                    
                    mealsViewModel.dependencies.meals.meals[0].isCollapsed = false
                    
                    mealsViewModel.input.expandButtonStateSubject.onNext(screenData.section[0])
                    expect(expandButton.events[0].value.element).toEventually(equal(false))
                    
                    mealsViewModel.input.expandButtonStateSubject.onNext(screenData.section[1])
                    expect(expandButton.events[1].value.element).toEventually(equal(true))
                    
                    mealsViewModel.input.expandButtonStateSubject.onNext(screenData.section[2])
                    expect(expandButton.events[2].value.element).toEventually(equal(true))
                    
                    mealsViewModel.input.expandButtonStateSubject.onNext(screenData.section[3])
                    expect(expandButton.events[3].value.element).toEventually(equal(true))
                }
                it("check setupCellData function"){
                    testScheduler.start()
                    
                    let data = screenData.section[0].data
                    expect(mealsViewModel.setupCellData(data: data[0]).0).toEventually(equal("COKOLADA 4 KOMADA"))
                    expect(mealsViewModel.setupCellData(data: data[0]).1).toEventually(equal("20"))
                    expect(mealsViewModel.setupCellData(data: data[0]).2).toEventually(equal(""))
                }
            }
        }
    }
    
}
