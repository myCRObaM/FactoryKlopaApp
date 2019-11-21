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
        
        public init(){
            
        }
    }
    
    public struct Output {
        
        public init(){
            
        }
    }
    
    public struct Dependencies {
        
        public init(){
            
        }
    }
    //MARK: Variables
    let dependencies: Dependencies
    var input: Input
    var output: Output
    
     //MARK: init
    public init(dependencies: WishListViewModel.Dependencies){
        self.dependencies = depencencies
    }
    
    //MARK: Transform
    public func transform(input: WishListViewModel.Input) -> WishListViewModel.Output {
        self.input = input
        var disposables = [Disposable]()
        
    }
}
