//
//  DataBaseStruct.swift
//  xmlParser
//
//  Created by Matej Hetzel on 23/10/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation

public struct RestorauntsModel: Decodable {
    public var name: String
    public var tel: String?
    public var mob: String?
    public var workingHours: String?
    public var meals: MealTypesModel
}
public struct MealsModel: Decodable {
    public var name: String
    public var priceNormal: String?
    public var priceJumbo: String?
    public var price: String?
    public var ingredients: [IngredientsModel]?
}

public struct IngredientsModel: Decodable {
    public var name: String?
}

public struct MealTypesModel: Decodable {
    public var desert: [MealsModel]?
    public var dodaci: [MealsModel]?
    public var hamburgeri: [MealsModel]?
    public var jelaPoNarudzbi: [MealsModel]?
    public var jelaSRostilja: [MealsModel]?
    public var kebabRazno: [MealsModel]?
    public var Ostalo: [MealsModel]?
    public var pizze: [MealsModel]?
    public var prilozi: [MealsModel]?
    public var ribljaJela: [MealsModel]?
    public var rizoto: [MealsModel]?
    public var salate: [MealsModel]?
    public var sendvici: [MealsModel]?
    public var tjestenine: [MealsModel]?
}
