//
//  SuitView.swift
//  RideTheBus
//
//  Created by Charlie DiGiovanna on 4/22/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import UIKit

class SuitView: UIView {
    @IBOutlet var content_view: UIView!
    @IBOutlet weak var player_label: UILabel!
    @IBOutlet weak var heart_button: UIButton!
    @IBOutlet weak var spade_button: UIButton!
    @IBOutlet weak var card_imageview: UIImageView!
    @IBOutlet weak var club_button: UIButton!
    @IBOutlet weak var diamond_button: UIButton!
    @IBOutlet weak var outcome_label: UILabel!
    @IBOutlet weak var beer_imageview: UIImageView!
    @IBOutlet weak var beer_imageview2: UIImageView!
    @IBOutlet weak var beer_imageview3: UIImageView!
    @IBOutlet weak var beer_imageview4: UIImageView!
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
        return button_tapped == heart_button && card!.suit == .hearts ||
               button_tapped == spade_button && card!.suit == .spades ||
               button_tapped == club_button && card!.suit == .clubs ||
               button_tapped == diamond_button && card!.suit == .diamonds
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
        Bundle.main.loadNibNamed("SuitView", owner: self, options: nil)
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
    
    func drawDrinks() {
        beer_imageview.isHidden = player!.drinks < 1
        beer_imageview2.isHidden = player!.drinks < 2
        beer_imageview3.isHidden = player!.drinks < 3
        beer_imageview4.isHidden = player!.drinks < 4
    }
    
    func disableButtons() {
        heart_button.isEnabled = false
        spade_button.isEnabled = false
        club_button.isEnabled = false
        diamond_button.isEnabled = false
    }
    
    func lowerAlphaOf(_ button: UIButton) {
        UIView.animate(withDuration: 0.5) {
            button.alpha = 0.3
        }
    }
    
    func revealCard() {
        let card_frame = CGRect(x: card_imageview.frame.minX + 20, y: card_imageview.frame.minY, width: card_imageview.frame.width - 40, height: card_imageview.frame.height)
        var cardView = CardView(frame: card_frame, card: card!)
        addSubview(cardView)
        card_imageview.isHidden = true
    }
    
    func revealOutcomeLabel() {
        outcome_label.text = guess_is_correct ? "SAFE!" : "DRINK!"
        if(!guess_is_correct){
            drinkAnimation()
        }
        outcome_label.isHidden = false
    }
    
    func drinkAnimation(){
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
                            completion: nil)
        cardView.isHidden = guess_is_correct ? false : true
        
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
    
    @IBAction func heartTapped(_ sender: Any) {
        buttonTapped(heart_button)
    }
    
    @IBAction func spadeTapped(_ sender: Any) {
        buttonTapped(spade_button)
    }
    
    @IBAction func clubTapped(_ sender: Any) {
        buttonTapped(club_button)
    }
    
    @IBAction func diamondTapped(_ sender: Any) {
        buttonTapped(diamond_button)
    }
    
    func buttonTapped(_ button: UIButton) {
        button_tapped = button
        disableButtons()
        for b in [heart_button, spade_button, club_button, diamond_button] {
            if b != button_tapped {
                lowerAlphaOf(b!)
            }
        }
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
