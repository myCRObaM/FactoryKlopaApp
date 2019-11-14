//
//  MainScreenViewModel.swift
//  KlopaFactory
//
//  Created by Matej Hetzel on 21/10/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import RxSwift

class MainScreenViewModel {
    //MARK: Defining structs
    struct Input {
        var startLoadingScreen: ReplaySubject<Bool>
    }
    struct Output {
        var disposables: [Disposable]
        var viewModelDone: ReplaySubject<Bool>
        var errorPopup: PublishSubject<Bool>
    }
    struct Dependencies {
        var scheduler: SchedulerType
    }
    //MARK: Vairables
    let dependencies: Dependencies
    var input: Input?
    var output: Output?
    //MARK: Init
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    //MARK: Transform
    func transform(input: MainScreenViewModel.Input) -> MainScreenViewModel.Output {
        var disposables = [Disposable]()
        self.input = input
        
        disposables.append(loadViewModel(subject: input.startLoadingScreen))
        
        self.output = Output(disposables: disposables, viewModelDone: ReplaySubject<Bool>.create(bufferSize: 1), errorPopup: PublishSubject())
        return output!
    }
    //MARK: Load view model
    func loadViewModel(subject: ReplaySubject<Bool>) -> Disposable {
        return subject
        .observeOn(MainScheduler.instance)
        .subscribeOn(dependencies.scheduler)
        .subscribe(onNext: {[unowned self]  bool in
            self.output?.viewModelDone.onNext(true)
        },
        onError: {[unowned self] bool in
            self.output?.errorPopup.onNext(true)
        })
    }
}
