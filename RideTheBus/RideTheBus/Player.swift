//
//  Player.swift
//  RideTheBus
//
//  Created by Charlie DiGiovanna on 4/22/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import Foundation


class Player {
    let name: String
    let number: Int
    var cards = [Card]()
    var drinks = 0
    
    init(name: String, number: Int) {
        self.name = name
        self.number = number
    }
    
    func getCards() -> [Card] {
        return cards
    }
    
    func getDrinks() -> Int {
        return drinks
    }
    
    func getName() -> String{
        return name
    }
    
    func addDrink() {
        drinks += 1
    }
}
