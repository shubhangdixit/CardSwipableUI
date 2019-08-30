//
//  SwipableCollectionViewCell.swift
//  CardSwipableUI
//
//  Created by Shubhang Dixit on 30/08/19.
//  Copyright © 2019 Shubhang. All rights reserved.
//
import UIKit

enum ButtonStackState {
    case left, right
}

class SwipableCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var buttonsStackLeadingConstraint : NSLayoutConstraint!
    @IBOutlet weak var buttonsStackTrailingConstraint: NSLayoutConstraint!
    
    var buttonsStackState : ButtonStackState = .right
    
    var buttons: [(name: String, type: ButtonType)] = []
    var pan: UIPanGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //commonInit()
    }
    
    override func awakeFromNib() {
        commonInit()
    }
    
    func setCardStyle(name : String, color : UIColor ) {
        cardName.text = name + " Color"
        mainView.backgroundColor = color
        for button in buttons {
            let newButton = UIButton(type: .custom)
            newButton.titleLabel?.text = button.name
            newButton.accessibilityIdentifier = button.type.rawValue
            newButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 12)
            newButton.titleLabel?.textColor = UIColor.white
            newButton.addTarget(self, action: #selector(handleButtonActions), for: .touchUpInside)
            buttonsStackView.addArrangedSubview(newButton)
        }
    }
    
    private func commonInit() {
        if true {
            pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
            pan.delegate = self
            mainView.addGestureRecognizer(pan)
            
           
        }
    }
    
    
    @objc func handleButtonActions(sender: UIButton){
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (pan != nil && pan.state == UIGestureRecognizer.State.changed) {
            let p: CGPoint = pan.translation(in: self)
            let width = self.mainView.frame.width
            let height = self.mainView.frame.height
            self.mainView.frame = CGRect(x: p.x,y: 0, width: width, height: height)
        }
    }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        if pan.state == UIGestureRecognizer.State.began {
            let velocity = pan.velocity(in: self)
            if velocity.x > 0 {
                changeButtonStackState(to: .left)
            } else {
                changeButtonStackState(to: .right)
            }
        } else if pan.state == UIGestureRecognizer.State.changed {
            self.setNeedsLayout()
        } else {
            
        }
    }
    
    func changeButtonStackState(to state:ButtonStackState) {
        if buttonsStackState != state {
            switch state {
            case .left :
                let shift = buttonsStackLeadingConstraint.constant
                buttonsStackLeadingConstraint.constant = 0
                buttonsStackTrailingConstraint.constant =  shift
            case .right:
                let shift = buttonsStackTrailingConstraint.constant
                buttonsStackTrailingConstraint.constant = 0
                buttonsStackLeadingConstraint.constant =  shift
            }
            buttonsStackView.layoutIfNeeded()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((pan.velocity(in: pan.view)).x) > abs((pan.velocity(in: pan.view)).y)
    }
}
