//
//  RedOrBlackView.swift
//  RideTheBus
//
//  Created by Charlie DiGiovanna on 4/22/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import UIKit

class RedOrBlackView: UIView {
    @IBOutlet var content_view: UIView!
    @IBOutlet weak var player_label: UILabel!
    @IBOutlet weak var bigBeer: UIImageView!
    @IBOutlet weak var red_button: UIButton!
    @IBOutlet weak var card_image: UIImageView!
    @IBOutlet weak var black_button: UIButton!
    @IBOutlet weak var outcome_label: UILabel!
    @IBOutlet weak var swipe_label: UILabel!
    @IBOutlet var swipe_recognizer: UISwipeGestureRecognizer!
    @IBOutlet weak var beer_imageview: UIImageView!
    var cardView: CardView!
    
    @IBAction func restartButton(_ sender: Any) {
        vc!.restart()
    }
    var vc: ViewController?
    var player: Player?
    var button_tapped: UIButton?
    var card: Card?
    var guess_is_correct: Bool {
            return (button_tapped == red_button && (card!.suit == .hearts || card!.suit == .diamonds)) || (button_tapped == black_button && (card!.suit == .spades || card!.suit == .clubs))
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
        Bundle.main.loadNibNamed("RedOrBlackView", owner: self, options: nil)
        guard let content = content_view else { return }
        content.frame = self.bounds
        self.addSubview(content)
    }
    
    func drawDrinks() {
        beer_imageview.isHidden = player!.drinks < 1
    }
    
    func pickCard() {
        if let card = DECK!.popRandom() {
            self.card = card
            player!.cards.append(card)
        }
    }
    
    func disableButtons() {
        red_button.isEnabled = false
        black_button.isEnabled = false
    }
    
    func lowerAlphaOf(_ button: UIButton) {
        UIView.animate(withDuration: 0.5) {
            button.alpha = 0.3
        }
    }
    
    func revealCard() {
        let card_frame = CGRect(x: card_image.frame.minX + 20, y: card_image.frame.minY, width: card_image.frame.width - 40, height: card_image.frame.height)
        cardView = CardView(frame: card_frame, card: card!)
        addSubview(cardView)
        card_image.isHidden = true
    }
    
    func revealOutcomeLabel() {
        outcome_label.text = guess_is_correct ? "SAFE!" : "DRINK!"
        drinkAnimation()
        outcome_label.isHidden = false
    }
    
    func drinkAnimation(){
        bigBeer.isHidden = guess_is_correct ? true : false
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
    
    @IBAction func redTapped(_ sender: Any) {
        buttonTapped(red_button)
    }

    @IBAction func blackTapped(_ sender: Any) {
        buttonTapped(black_button)
    }
    
    func buttonTapped(_ button: UIButton) {
        button_tapped = button
        disableButtons()
        lowerAlphaOf(button == red_button ? black_button : red_button)
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
