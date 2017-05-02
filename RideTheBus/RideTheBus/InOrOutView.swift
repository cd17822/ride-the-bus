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
    var cardView: CardView!
    
    
    @IBOutlet weak var bigBeer: UIImageView!
    
    @IBAction func restartButton(_ sender: Any) {
        vc!.restart()
    }
    var vc: ViewController?
    var player: Player?
    var button_tapped: UIButton?
    var card: Card?
    var guess_is_correct: Bool {
        let lesser_val = min(player!.cards[0].val, player!.cards[1].val)
        let greater_val = max(player!.cards[0].val, player!.cards[1].val)
        let inb = lesser_val < card!.val && greater_val > card!.val
        let out = lesser_val > card!.val || greater_val < card!.val
        return button_tapped == in_button && inb || button_tapped == out_button && out
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
        cardView = CardView(frame: card_frame, card: card!)
        addSubview(cardView)
        card_imageview.isHidden = true
    }
    
    func drinkAnimationIn(){
        insertSubview(self.bigBeer, aboveSubview: cardView)
        self.bigBeer.transform = CGAffineTransform(scaleX: 0.3, y: 2)
        UIImageView.animate(withDuration: 1.5,
                            delay: 0,
                            usingSpringWithDamping: 0.5,
                            initialSpringVelocity: 0,
                            options: .curveEaseIn,
                            animations: {
                                self.bigBeer.alpha = 1.0
                                self.bigBeer.transform = .identity
                                self.bigBeer.layoutIfNeeded()
        },
                            completion: nil
        )
    }
    func drinkAnimationOut(){
        UIImageView.animate(withDuration: 0.6,
                            delay: 1.0,
                            options: .curveEaseOut,
                            animations: {
                                self.bigBeer.alpha = 0.0
                                self.isOpaque = false
                                self.bigBeer.layoutIfNeeded()
        },
                            completion: {(finished: Bool) in
                                self.bigBeer.removeFromSuperview()
                                
        })
    }
    
    func revealOutcomeLabel() {
        outcome_label.text = guess_is_correct ? "SAFE!" : "DRINK!"
        if(!guess_is_correct){
            drinkAnimationIn()
            drinkAnimationOut()
        }
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
        if((player?.getDrinks())! > (vc?.mostDrinksPlayer?.getDrinks())!){
            vc?.mostDrinksPlayer = player
        }
        
        if((player?.getDrinks())! < (vc?.leastDrinksPlayer?.getDrinks())!){
            vc?.leastDrinksPlayer = player
        }
        vc!.registerViewSwipe()
    }

}
