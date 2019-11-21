//
//  WishListViewModel.swift
//  WishList
//
//  Created by Matej Hetzel on 21/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import RxSwift

public class WishListViewModel{
    //MARK: Defining structs
    public struct Input {
        var getData: ReplaySubject<Bool>
    }
    
    public struct Output {
        var dataReady: ReplaySubject<Bool>
        var disposables: [Disposable]
    }
    
    public struct Dependencies {
        var scheduler: SchedulerType
    }
    //MARK: Variables
    let dependencies: Dependencies
    var input: Input!
    var output: Output!
    
     //MARK: init
    public init(dependencies: WishListViewModel.Dependencies){
        self.dependencies = dependencies
    }
    
    //MARK: Transform
    public func transform(input: WishListViewModel.Input) -> WishListViewModel.Output {
        self.input = input
        var disposables = [Disposable]()
        
        disposables.append(getData(subject: input.getData))
        
        self.output = WishListViewModel.Output(dataReady: ReplaySubject<Bool>.create(bufferSize: 1), disposables: disposables)
        return output
    }
    
    func getData(subject: ReplaySubject<Bool>) -> Disposable{
        return subject
        .observeOn(MainScheduler.instance)
        .subscribeOn(dependencies.scheduler)
        .subscribe(onNext: { [unowned self] bool in
                self.output.dataReady.onNext(true)
            })
    }
}
