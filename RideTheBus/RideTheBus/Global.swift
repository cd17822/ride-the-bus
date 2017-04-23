//
//  Global.swift
//  RideTheBus
//
//  Created by Charlie DiGiovanna on 4/22/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// MARK: - Global variables

var DECK: Deck?

// MARK: - Global functions

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

func random(min: Int, max: Int) -> Int {
    return Int(random(min: CGFloat(min), max: CGFloat(max)))
}

// MARK: - Extensions

extension UIColor {
    static var backgroundColor: UIColor {
        return UIColor(red:0.40, green:0.79, blue:0.30, alpha:1.00)
    }
}

extension CGRect {
    func intersectsAnyOf(_ otherViews: [UIView]) -> Bool {
        for v in otherViews {
            if self.intersects(v.frame) {
                print(self)
                print(v.frame)
                return true
            }
        }
        
        return false
    }
}
