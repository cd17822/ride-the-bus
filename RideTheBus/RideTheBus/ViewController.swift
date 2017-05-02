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
    var mostDrinksPlayer: Player!
    var leastDrinksPlayer: Player!
    @IBOutlet weak var bigBus: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.addSubview(self.bigBus)
        updateNumPlayersLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func busAnimationIn(){
        self.view.insertSubview(self.bigBus, aboveSubview: self.view)
        self.bigBus.transform = CGAffineTransform(scaleX: 0.3, y: 2)
        UIImageView.animate(withDuration: 1.5,
                            delay: 0,
                            usingSpringWithDamping: 0.5,
                            initialSpringVelocity: 0,
                            options: .curveEaseIn,
                            animations: {
                                self.bigBus.alpha = 1.0
                                self.bigBus.transform = .identity
                                self.bigBus.layoutIfNeeded()
        },
                            completion: {(finished: Bool) in
                                self.bigBus.alpha = 0.0
        })
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
        busAnimationIn()
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
        mostDrinksPlayer = players[0]
        leastDrinksPlayer = players[0]
    }
    
    func createNibs() {
        for player in players {
            nibs.append(RedOrBlackView(frame: view.frame.offsetBy(dx: view.frame.width, dy: 0), vc: self, player: player))
        }
        for player in players {
            nibs.append(HigherOrLowerView(frame: view.frame.offsetBy(dx: view.frame.width, dy: 0), vc: self, player: player))
        }
        for player in players {
            nibs.append(InOrOutView(frame: view.frame.offsetBy(dx: view.frame.width, dy: 0), vc: self, player: player))
        }
        for player in players {
            nibs.append(SuitView(frame: view.frame.offsetBy(dx: view.frame.width, dy: 0), vc: self, player: player))
        }
        nibs.append(ResultsView(frame: view.frame.offsetBy(dx: view.frame.width, dy: 0), vc: self))
        nibs[0].frame = view.frame
    }
    
    func presentNib(atIndex index: Int) {
        blanket_view!.addSubview(nibs[index])
    }
//    
//    func presentResultsView(previous_nib: UIView) {
//        blanket_view = UIView(frame: view.frame)
//        blanket_view!.backgroundColor = .backgroundColor
//        blanket_view!.alpha = 0
//        view.addSubview(blanket_view!)
//        
//        UIView.animate(withDuration: 1,
//                       animations: {
//                        self.blanket_view!.alpha = 1
//                        },
//                       completion: {_ in
//                                    previous_nib.removeFromSuperview()
//        
//        })
////        UIView.animate(withDuration: 1) {
////            self.blanket_view!.alpha = 1
////        }
//        blanket_view!.addSubview(ResultsView(frame: view.frame.offsetBy(dx: view.frame.width, dy: 0), vc: self))
//    }
    
//    func getResults(previous_nib: UIView){
//        for player in players{
//            if(player.getDrinks() > mostDrinksPlayer.getDrinks()){
//                mostDrinksPlayer = player
//            }
//            if(player.getDrinks() < leastDrinksPlayer.getDrinks()){
//                leastDrinksPlayer = player
//            }
//        }
//        presentResultsView(previous_nib: previous_nib)
//        
//    }
    
    func registerViewSwipe() {
        print(mostDrinksPlayer?.getName() ?? "not assigned")
        print(leastDrinksPlayer?.getName() ?? "not assigned")
        
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
        
        current_nib.layoutIfNeeded()
        // yeah i know i should make a protocol that they follow blah blah blah
        (current_nib as? HigherOrLowerView)?.drawDrinks()
        (current_nib as? HigherOrLowerView)?.drawFirstCard()
        (current_nib as? InOrOutView)?.drawDrinks()
        (current_nib as? InOrOutView)?.drawFirstCard()
        (current_nib as? InOrOutView)?.drawSecondCard()
        (current_nib as? SuitView)?.drawDrinks()
        
        
        UIView.animate(withDuration: 1, animations: {
            previous_nib.frame = previous_nib.frame.offsetBy(dx: -self.view.frame.width, dy: 0)
            current_nib.frame = self.view.frame
        }, completion: { _ in
            previous_nib.removeFromSuperview()
        })
    }
    func restart(){
        nibs.removeAll()
        players.removeAll()
        UIView.animate(withDuration: 1, animations: {
            self.blanket_view!.alpha = 0
        }, completion: { _ in
            self.blanket_view!.removeFromSuperview()
        })
        return
    }
}

