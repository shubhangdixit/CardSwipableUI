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
    
    override func awakeFromNib() {
        commonInit()
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 20
        baseView.layer.cornerRadius = 20
        baseView.layer.masksToBounds = true
    }
    
    func setCardStyle(name : String, color : UIColor ) {
        cardName.text = name + " Card"
        mainView.backgroundColor = color
        
        if buttonsStackView.arrangedSubviews.count > 0 {
            emptyStackView()
        }
        
        for button in buttons {
            buttonsStackView.addArrangedSubview(getButton(forTitle: button.name, identifier: button.type.rawValue))
        }
    }
    
    private func commonInit() {
        if true {
            pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
            pan.delegate = self
            mainView.addGestureRecognizer(pan)
        }
    }
    
    func getButton(forTitle title : String, identifier : String) -> UIButton {
        let newButton = UIButton(type: .custom)
        newButton.setTitle(title, for: .normal)
        newButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 15)
        newButton.setTitleColor(.white, for: .normal)
        newButton.accessibilityIdentifier = identifier
        newButton.addTarget(self, action: #selector(handleButtonActions), for: .touchUpInside)
        return newButton
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
                buttonsStackState = .left
            case .right:
                let shift = buttonsStackTrailingConstraint.constant
                buttonsStackTrailingConstraint.constant = 0
                buttonsStackLeadingConstraint.constant =  shift
                buttonsStackState = .right
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
    
    func emptyStackView() {
        let views = buttonsStackView.arrangedSubviews
        for view in views {
            buttonsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
