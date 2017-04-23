//
//  CardView.swift
//  RideTheBus
//
//  Created by Charlie DiGiovanna on 4/22/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import UIKit

class CardView: UIView {
    @IBOutlet var content_view: UIView!
    @IBOutlet weak var val_label: UILabel!
    
    var card: Card?
    
    convenience init(frame: CGRect, card: Card) {
        self.init(frame: frame)
        
        self.card = card
        drawCard()
    }
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.loadNib()
    }
    
    private func loadNib() {
        Bundle.main.loadNibNamed("CardView", owner: self, options: nil)
        guard let content = content_view else { return }
        content.frame = self.bounds
        self.addSubview(content)
    }
    
    func drawCard() {
        switch card!.suit {
        case .hearts:
            val_label.text = "\(card!.val)♥️"
            val_label.textColor = .red
        case .clubs:
            val_label.text = "\(card!.val)♣️"
        case .diamonds:
            val_label.text = "\(card!.val)♦️"
            val_label.textColor = .red
        case .spades:
            val_label.text = "\(card!.val)♠️"
        }
    }
}
