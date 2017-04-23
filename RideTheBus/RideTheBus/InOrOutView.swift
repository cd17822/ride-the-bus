//
//  InOrOutView.swift
//  RideTheBus
//
//  Created by Charlie DiGiovanna on 4/22/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import UIKit

class InOrOutView: UIView {
    @IBOutlet var content_view: UIView!
    @IBOutlet weak var player_label: UILabel!
    @IBOutlet weak var out_button: UIButton!
    @IBOutlet weak var card_imageview: UIImageView!
    @IBOutlet weak var in_button: UIButton!
    @IBOutlet weak var outcome_label: UILabel!
    @IBOutlet weak var beer_imageview: UIImageView!
    @IBOutlet weak var beer_imageview2: UIImageView!
    @IBOutlet weak var beer_imageview3: UIImageView!
    @IBOutlet weak var swipe_label: UILabel!
    @IBOutlet var swipe_recognizer: UISwipeGestureRecognizer!
    
    var vc: ViewController?
    var player: Player?
    var button_tapped: UIButton?
    var card: Card?
    var guess_is_correct: Bool {
        let range_start = min(player!.cards[0].val, player!.cards[1].val) + 1
        let range_end = max(player!.cards[0].val, player!.cards[1].val) - 1
        if range_start <= range_end {
            return button_tapped == out_button && card!.val != player!.cards[0].val && card!.val != player!.cards[1].val
        }
        return (button_tapped == out_button && !(range_start...range_end).contains(card!.val)) || (button_tapped == in_button && (range_start...range_end).contains(card!.val))
    }
    
    convenience init(frame: CGRect, vc: ViewController, player: Player) {
        self.init(frame: frame)
        
        self.vc = vc
        self.player = player
        self.player_label.text = player.name
        
        pickCard()
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
        Bundle.main.loadNibNamed("InOrOutView", owner: self, options: nil)
        guard let content = content_view else { return }
        content.frame = self.bounds
        self.addSubview(content)
    }
    
    func pickCard() {
        if let card = DECK!.popRandom() {
            self.card = card
            player!.cards.append(card)
        }
    }
    
    func drawFirstCard() {
        let card_frame = CGRect(x: out_button.frame.minX - 85, y: card_imageview.frame.minY, width: card_imageview.frame.width - 40, height: card_imageview.frame.height)
        let cv = CardView(frame: card_frame, card: player!.cards[0])
        addSubview(cv)
    }
    
    func drawSecondCard() {
        let card_frame = CGRect(x: out_button.frame.minX + 48, y: card_imageview.frame.minY - 10, width: card_imageview.frame.width - 40, height: card_imageview.frame.height)
        let cv = CardView(frame: card_frame, card: player!.cards[1])
        addSubview(cv)
    }
    
    func drawDrinks() {
        beer_imageview.isHidden = player!.drinks < 1
        beer_imageview2.isHidden = player!.drinks < 2
        beer_imageview3.isHidden = player!.drinks < 3
    }
    
    func disableButtons() {
        out_button.isEnabled = false
        in_button.isEnabled = false
    }
    
    func lowerAlphaOf(_ button: UIButton) {
        UIView.animate(withDuration: 0.5) {
            button.alpha = 0.3
        }
    }
    
    func revealCard() {
        let card_frame = CGRect(x: card_imageview.frame.minX + 20, y: card_imageview.frame.minY, width: card_imageview.frame.width - 40, height: card_imageview.frame.height)
        let cv = CardView(frame: card_frame, card: card!)
        addSubview(cv)
        card_imageview.isHidden = true
    }
    
    func revealOutcomeLabel() {
        outcome_label.text = guess_is_correct ? "SAFE!" : "DRINK!"
        outcome_label.isHidden = false
    }
    
    func updatePlayer() {
        if !guess_is_correct {
            player!.addDrink()
        }
    }
    
    func revealSwipeLabel() {
        UIView.animate(withDuration: 1) {
            self.swipe_label.alpha = 1
        }
    }
    
    func enableSwipe() {
        swipe_recognizer.isEnabled = true
    }
    
    @IBAction func outTapped(_ sender: Any) {
        buttonTapped(out_button)
    }
    
    @IBAction func inTapped(_ sender: Any) {
        buttonTapped(in_button)
    }
    
    func buttonTapped(_ button: UIButton) {
        button_tapped = button
        disableButtons()
        lowerAlphaOf(button == out_button ? in_button : out_button)
        revealCard()
        revealOutcomeLabel()
        updatePlayer()
        revealSwipeLabel()
        enableSwipe()
        drawDrinks()
    }
    
    @IBAction func swipeRecognized(_ sender: Any) {
        vc!.registerViewSwipe()
    }

}
