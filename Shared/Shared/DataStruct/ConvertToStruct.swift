//
//  ConvertToStruct.swift
//  Shared
//
//  Created by Matej Hetzel on 06/11/2019.
//  Copyright © 2019 Matej Hetzel. All rights reserved.
//

import Foundation
public class ConvertToStruct {
    public func convertToStruct(restoraunts: [RestorauntsModel]) -> [Restoraunts] {
           var restorauntsClass = [Restoraunts]()
           for restoraint in restoraunts {
               restorauntsClass.append(Restoraunts(name: restoraint.name, tel: restoraint.tel, mob: restoraint.mob, workingHours: restoraint.workingHours, meals: convertToMealsStruct(meals: restoraint.meals)))
           }
           return restorauntsClass
       }
    
   public func convertToMealsStruct(meals: MealTypesModel) -> [MealTypes] {
        var mealsArray = [Meals]()
        var localMealTypesArray = [MealTypes]()
        
        if meals.desert != nil && meals.desert?.count ?? 0 > 0 {
            mealsArray.removeAll()
            for meal in meals.desert! {
                mealsArray.append(Meals(name: meal.name, priceNormal: meal.priceNormal, priceJumbo: meal.priceJumbo, price: meal.price, ingredients: returnIngredients(ingredients: meal.ingredients)))
            }
            localMealTypesArray.append(MealTypes(type: .desert, meals: mealsArray))
        }
        if meals.pizze != nil && meals.pizze?.count ?? 0 > 0{
            mealsArray.removeAll()
            for meal in meals.pizze! {
                mealsArray.append(Meals(name: meal.name, priceNormal: meal.priceNormal, priceJumbo: meal.priceJumbo, price: meal.price, ingredients: returnIngredients(ingredients: meal.ingredients)))
            }
            localMealTypesArray.append(MealTypes(type: .pizza, meals: mealsArray))
        }
        if meals.dodaci != nil && meals.dodaci?.count ?? 0 > 0{
            mealsArray.removeAll()
                   for meal in meals.dodaci! {
                       mealsArray.append(Meals(name: meal.name, priceNormal: meal.priceNormal, priceJumbo: meal.priceJumbo, price: meal.price, ingredients: returnIngredients(ingredients: meal.ingredients)))
                   }
            localMealTypesArray.append(MealTypes(type: .additions, meals: mealsArray))
               }
        if meals.hamburgeri != nil && meals.hamburgeri?.count ?? 0 > 0{
            mealsArray.removeAll()
                   for meal in meals.hamburgeri! {
                       mealsArray.append(Meals(name: meal.name, priceNormal: meal.priceNormal, priceJumbo: meal.priceJumbo, price: meal.price, ingredients: returnIngredients(ingredients: meal.ingredients)))
                   }
            localMealTypesArray.append(MealTypes(type: .hamburgers, meals: mealsArray))
               }
        if meals.jelaPoNarudzbi != nil && meals.jelaPoNarudzbi?.count ?? 0 > 0{
            mealsArray.removeAll()
                   for meal in meals.jelaPoNarudzbi! {
                       mealsArray.append(Meals(name: meal.name, priceNormal: meal.priceNormal, priceJumbo: meal.priceJumbo, price: meal.price, ingredients: returnIngredients(ingredients: meal.ingredients)))
                   }
            localMealTypesArray.append(MealTypes(type: .mealsByOrder, meals: mealsArray))
               }
        if meals.jelaSRostilja != nil && meals.jelaSRostilja?.count ?? 0 > 0{
            mealsArray.removeAll()
            for meal in meals.jelaSRostilja! {
                mealsArray.append(Meals(name: meal.name, priceNormal: meal.priceNormal, priceJumbo: meal.priceJumbo, price: meal.price, ingredients: returnIngredients(ingredients: meal.ingredients)))
            }
            localMealTypesArray.append(MealTypes(type: .grillMeals, meals: mealsArray))
        }
        if meals.kebabRazno != nil && meals.kebabRazno?.count ?? 0 > 0{
            mealsArray.removeAll()
            for meal in meals.kebabRazno! {
                mealsArray.append(Meals(name: meal.name, priceNormal: meal.priceNormal, priceJumbo: meal.priceJumbo, price: meal.price, ingredients: returnIngredients(ingredients: meal.ingredients)))
            }
            localMealTypesArray.append(MealTypes(type: .kebab, meals: mealsArray))
        }
        if meals.Ostalo != nil && meals.Ostalo?.count ?? 0 > 0{
            mealsArray.removeAll()
            for meal in meals.Ostalo! {
                mealsArray.append(Meals(name: meal.name, priceNormal: meal.priceNormal, priceJumbo: meal.priceJumbo, price: meal.price, ingredients: returnIngredients(ingredients: meal.ingredients)))
            }
            localMealTypesArray.append(MealTypes(type: .other, meals: mealsArray))
        }
        if meals.prilozi != nil && meals.prilozi?.count ?? 0 > 0{
            mealsArray.removeAll()
            for meal in meals.prilozi! {
                mealsArray.append(Meals(name: meal.name, priceNormal: meal.priceNormal, priceJumbo: meal.priceJumbo, price: meal.price, ingredients: returnIngredients(ingredients: meal.ingredients)))
            }
            localMealTypesArray.append(MealTypes(type: .side, meals: mealsArray))
        }
        if meals.ribljaJela != nil && meals.ribljaJela?.count ?? 0 > 0{
            mealsArray.removeAll()
            for meal in meals.ribljaJela! {
                mealsArray.append(Meals(name: meal.name, priceNormal: meal.priceNormal, priceJumbo: meal.priceJumbo, price: meal.price, ingredients: returnIngredients(ingredients: meal.ingredients)))
            }
            localMealTypesArray.append(MealTypes(type: .fishMeals, meals: mealsArray))
        }
        if meals.rizoto != nil && meals.rizoto?.count ?? 0 > 0{
            mealsArray.removeAll()
            for meal in meals.rizoto! {
                mealsArray.append(Meals(name: meal.name, priceNormal: meal.priceNormal, priceJumbo: meal.priceJumbo, price: meal.price, ingredients: returnIngredients(ingredients: meal.ingredients)))
            }
            localMealTypesArray.append(MealTypes(type: .riceMeals, meals: mealsArray))
        }
        if meals.salate != nil && meals.salate?.count ?? 0 > 0{
            mealsArray.removeAll()
            for meal in meals.salate! {
                mealsArray.append(Meals(name: meal.name, priceNormal: meal.priceNormal, priceJumbo: meal.priceJumbo, price: meal.price, ingredients: returnIngredients(ingredients: meal.ingredients)))
            }
            localMealTypesArray.append(MealTypes(type: .salad, meals: mealsArray))
        }
        if meals.sendvici != nil && meals.sendvici?.count ?? 0 > 0{
            mealsArray.removeAll()
            for meal in meals.sendvici! {
                mealsArray.append(Meals(name: meal.name, priceNormal: meal.priceNormal, priceJumbo: meal.priceJumbo, price: meal.price, ingredients: returnIngredients(ingredients: meal.ingredients)))
            }
            localMealTypesArray.append(MealTypes(type: .sendwich, meals: mealsArray))
        }
        if meals.tjestenine != nil && meals.tjestenine?.count ?? 0 > 0{
            mealsArray.removeAll()
            for meal in meals.tjestenine! {
                mealsArray.append(Meals(name: meal.name, priceNormal: meal.priceNormal, priceJumbo: meal.priceJumbo, price: meal.price, ingredients: returnIngredients(ingredients: meal.ingredients)))
            }
            localMealTypesArray.append(MealTypes(type: .pasta, meals: mealsArray))
        }
        
        return localMealTypesArray
    }
    
    public func returnIngredients(ingredients: [IngredientsModel]?) -> [Ingredients] {
        var ingredientsArray = [Ingredients]()
        if ingredients != nil {
            for ingredient in ingredients! {
                ingredientsArray.append(Ingredients(name: ingredient.name))
            }
        }
        
        return ingredientsArray
    }
    
    public init() {
    }
}
