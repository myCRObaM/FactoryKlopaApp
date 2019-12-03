//
//  DatabaseManager.swift
//  Shared
//
//  Created by Matej Hetzel on 21/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift


public class RealmManager {
    
    let realm = try? Realm()
    
    public init(){}
    
    //MARK: Delete location
    public func deleteMeal(name: String) -> Observable<String>{
        guard let realmMeal = self.realm?.object(ofType: RealmRestorauntsDataModel.self, forPrimaryKey: name) else { return Observable.just("Object not found!")}
        
        do{
            try self.realm?.write {
                self.realm?.delete(realmMeal)
            }
        }catch{
            return Observable.just("Error deleting object!")
        }
        return Observable.just("Object deleted!")
    }
    
    //MARK: Save location
    public func saveMeal(meal: MealsWithRestoraunt) -> Observable<String>{
        let realmRestoraunt = RealmRestorauntsDataModel()
        realmRestoraunt.createRestoraunt(meal: meal)
        do{
            try realm?.write {
                realm?.add(realmRestoraunt, update: .all)
            }
        }catch{
            return Observable.just("Error saving object!")
        }
        return Observable.just("Object saved!")
    }
    
    //MARK: Get all locations
    public func getMeals() -> [MealsWithRestoraunt]{
        let backThreadRealm = try! Realm()
        let realmRestoraunt = backThreadRealm.objects(RealmRestorauntsDataModel.self)
        var restoraunts: [MealsWithRestoraunt] = []
        for realmMeal in realmRestoraunt{
            let meal = MealsWithRestoraunt(name: realmMeal.name, priceNormal: "", priceJumbo: "", price: realmMeal.price, ingredients: [Ingredients(name: realmMeal.ingredients)], restorauntName: realmMeal.restoraunt, mobLabel: realmMeal.mob, telLabel: realmMeal.tel)
            restoraunts.append(meal)
        }
        return restoraunts
    }
}
