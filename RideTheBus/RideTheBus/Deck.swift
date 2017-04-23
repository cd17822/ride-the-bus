//
//  Deck.swift
//  RideTheBus
//
//  Created by Charlie DiGiovanna on 4/22/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import Foundation

class Deck {
    var cards = [Card]()
    
    init() {
        let suits: [Suit] = [.hearts, .diamonds, .clubs, .spades]
        for i in [1,2,3,4,5,6,7,8,9,10,11,12,13] {
            for s in suits {
                cards.append(Card(suit: s, val: i))
            }
        }
    }
    
    func popRandom() -> Card? {
        guard cards.count > 0 else {
            print("No more cards left")
            return nil
        }
        
        return cards.remove(at: random(min: 0, max: cards.count))
    }
}
