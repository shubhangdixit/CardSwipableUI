//
//  SwipableCollectionViewCell.swift
//  CardSwipableUI
//
//  Created by Shubhang Dixit on 30/08/19.
//  Copyright © 2019 Shubhang. All rights reserved.
//
import UIKit

protocol SwipableCardButtonActionDelegate {
    func registerAction(forIdentifier iD : String)
}

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
    
    var delegate : SwipableCardButtonActionDelegate?
    
    var swipableCardOriginX : CGFloat = 0                   // Stores initial origin before swipe begins
    var buttonsStackState : ButtonStackState = .right       // state of stack view , left or Right
    var buttons: [(name: String, type: ButtonType)] = []    // List of buttons to be visisble after Swipe
    var pan: UIPanGestureRecognizer!
    
    override func awakeFromNib() {
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 20
        baseView.layer.cornerRadius = 20
        baseView.layer.masksToBounds = true
    }
    
    func setCardStyle(name : String, color : UIColor ) {
        cardName.text = name + " Card"
        mainView.backgroundColor = color
        
        if buttonsStackView.arrangedSubviews.count > 0 {
            emptyStackView()     // empty stack view for reusing cell
        }
        
        for button in buttons {
            buttonsStackView.addArrangedSubview(getButton(forTitle: button.name, identifier: button.type.rawValue))
        }
        setUpGestures()
    }
    
    private func setUpGestures() {
        if buttons.count > 0 {       // no Swipe if no buttons to show ater swipe
            pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
            pan.delegate = self
            mainView.addGestureRecognizer(pan)
        }
    }
    
    @objc func handleButtonActions(sender: UIButton){
        if (delegate != nil) {
            delegate?.registerAction(forIdentifier: sender.accessibilityIdentifier ?? "")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        
        let velocity = pan.velocity(in: self)
        let baseX = baseView.frame.origin.x
        let swipableLength = mainView.frame.width / 2   // card can only be swiped to half of its length
        let width = self.mainView.frame.width
        let height = self.mainView.frame.height
        
        switch pan.state {
        case .began:
            swipableCardOriginX = mainView.frame.origin.x
            if swipableCardOriginX == baseView.frame.origin.x {
                velocity.x > 0 ? changeButtonStackState(to: .left) : changeButtonStackState(to: .right)
            }
            
        case .changed:
            let p: CGPoint = pan.translation(in: mainView)
            if p.x >= (baseX - swipableLength) && p.x <= (baseX + swipableLength) {
                self.mainView.frame = CGRect(x: swipableCardOriginX + p.x, y: 0, width: width, height: height)
            }
            self.setNeedsLayout()
            
        case .ended:
            let finalX = mainView.frame.origin.x   // main views final position after swipe ended
            let p = swipableLength / 5
            if velocity.x > 0 {
                if finalX < (baseX - (p * 4)) {
                    animateSwipe(toPosition: baseX - swipableLength)
                } else if finalX >= (baseX - (p * 4)) && finalX < p {
                    animateSwipe(toPosition: baseX)
                } else {
                    animateSwipe(toPosition: baseX + swipableLength)
                }
            } else {
                if finalX > (baseX + (p * 4)) {
                    animateSwipe(toPosition: baseX + swipableLength)
                } else if finalX >= (baseX - p) && finalX <= (baseX + (p * 4))  {
                    animateSwipe(toPosition: baseX)
                } else {
                    animateSwipe(toPosition: baseX - swipableLength)
                }
            }
            
        default:
            break
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
    
    // MARK: UIGestureRecognizerDelegate functions
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((pan.velocity(in: pan.view)).x) > abs((pan.velocity(in: pan.view)).y)
    }
    
    func animateSwipe(toPosition x:CGFloat) {
        
        let width = self.mainView.frame.width
        let height = self.mainView.frame.height
        
        UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.mainView.frame = CGRect(x: x, y: 0, width: width, height: height)
            self.contentView.layoutIfNeeded()
        }) { (_) in
        }
    }
    
    // MARK:  utility functions
    
    func getButton(forTitle title : String, identifier : String) -> UIButton {
        let newButton = UIButton(type: .custom)
        newButton.setTitle(title, for: .normal)
        newButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 15)
        newButton.setTitleColor(.white, for: .normal)
        newButton.accessibilityIdentifier = identifier
        newButton.addTarget(self, action: #selector(handleButtonActions), for: .touchUpInside)
        return newButton
    }
    
    func emptyStackView() {
        let views = buttonsStackView.arrangedSubviews
        for view in views {
            buttonsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
