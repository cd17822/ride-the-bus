//
//  Card.swift
//  RideTheBus
//
//  Created by Charlie DiGiovanna on 4/22/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import Foundation

enum Suit {
    case hearts, spades, diamonds, clubs
}

class Card {
    let suit: Suit
    let val: Int
    
    init(suit: Suit, val: Int) {
        self.val = val
        self.suit = suit
    }
}
