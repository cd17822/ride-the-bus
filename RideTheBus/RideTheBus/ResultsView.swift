//
//  SuitView.swift
//  RideTheBus
//
//  Created by Charlie DiGiovanna on 4/22/17.
//  Copyright © 2017 Charlie DiGiovanna. All rights reserved.
//

import UIKit

class ResultsView: UIView {
    @IBOutlet var content_view: UIView!

    @IBOutlet weak var swipe_label: UILabel!
    @IBOutlet weak var mostDrinksPlayerLabel: UILabel!
    @IBOutlet weak var leastDrinksPlayerLabel: UILabel!
    @IBOutlet var swipe_recognizer: UISwipeGestureRecognizer!
    
    var vc: ViewController?
    var button_tapped: UIButton?
    
    convenience init(frame: CGRect, vc: ViewController) {
        self.init(frame: frame)
        self.vc = vc
        self.mostDrinksPlayerLabel.text = vc.mostDrinksPlayer.name
        self.leastDrinksPlayerLabel.text = vc.leastDrinksPlayer.name
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
        Bundle.main.loadNibNamed("ResultsView", owner: self, options: nil)
        guard let content = content_view else { return }
        content.frame = self.bounds
        self.addSubview(content)
    }
    
    @IBAction func restartButton(_ sender: Any) {
        vc!.restart()
    }

}
