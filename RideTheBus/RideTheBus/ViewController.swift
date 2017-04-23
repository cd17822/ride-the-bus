//
//  ViewController.swift
//  RideTheBus
//
//  Created by Charlie DiGiovanna on 4/22/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var blanket_view: UIView?
    var num_players = 2
    @IBOutlet weak var num_players_label: UILabel!
    var players = [Player]()
    var nibs = [UIView]()
    var nib_index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateNumPlayersLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateNumPlayersLabel() {
        num_players_label.text = "\(num_players)"
    }
    
    @IBAction func minusTapped(_ sender: Any) {
        if num_players <= 1 { return }
        num_players -= 1
        updateNumPlayersLabel()
    }
    
    @IBAction func plusTapped(_ sender: Any) {
        if num_players >= 15 { return }
        num_players += 1
        updateNumPlayersLabel()
    }
    
    @IBAction func getStartedTapped(_ sender: Any) {
        initDeck()
        nib_index = 0
        presentBlanketView()
        createPlayers()
        createNibs()
        presentNib(atIndex: nib_index)
    }
    
    func initDeck() {
        DECK = Deck()
    }
    
    func presentBlanketView() {
        blanket_view = UIView(frame: view.frame)
        blanket_view!.backgroundColor = .backgroundColor
        blanket_view!.alpha = 0
        view.addSubview(blanket_view!)
        
        UIView.animate(withDuration: 1) {
            self.blanket_view!.alpha = 1
        }
    }
    
    func createPlayers() {
        for i in 0..<num_players {
            players.append(Player(name: "Player \(i+1)", number: i+1))
        }
    }
    
    func createNibs() {
        for player in players {
            nibs.append(RedOrBlackView(frame: view.frame.offsetBy(dx: self.view.frame.width, dy: 0), vc: self, player: player))
        }
        for player in players {
            nibs.append(HigherOrLowerView(frame: view.frame.offsetBy(dx: self.view.frame.width, dy: 0), vc: self, player: player))
        }
//        for player in players {
//            // nibs.append(otherscreen)
//        }
//        for player in players {
//            // nibs.append(otherscreen)
//        }
        
        nibs[0].frame = view.frame
    }
    
    func presentNib(atIndex index: Int) {
        blanket_view!.addSubview(nibs[index])
    }
    
    func registerViewSwipe() {
        let previous_nib = nibs[nib_index]
        
        nib_index += 1
        
        if nib_index == nibs.count { // go back to home screen
            nibs.removeAll()
            players.removeAll()
            UIView.animate(withDuration: 1, animations: {
                self.blanket_view!.alpha = 0
            }, completion: { _ in
                self.blanket_view!.removeFromSuperview()
            })
            return
        }
        
        presentNib(atIndex: nib_index)
        let current_nib = nibs[nib_index]
        (current_nib as? HigherOrLowerView)?.drawDrinks()
    
        UIView.animate(withDuration: 1, animations: {
            previous_nib.frame = previous_nib.frame.offsetBy(dx: -self.view.frame.width, dy: 0)
            current_nib.frame = self.view.frame
        }, completion: { _ in
            previous_nib.removeFromSuperview()
        })
    }
}

