//
//  ViewController.swift
//  CardSwipableUI
//
//  Created by Shubhang Dixit on 30/08/19.
//  Copyright © 2019 Shubhang. All rights reserved.
//

import UIKit

enum ButtonType : String {
    case first = "Pay", second = "History" , third = "Info"
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SwipableCardButtonActionDelegate {
    
    @IBOutlet weak var tutorialView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var activeCell: SwipableCollectionViewCell?
    var activeCellIndex: Int?
    // Data source for number of cards
    let cards : [(name: String, type: UIColor)] = [(name:"Blue", type:.blue),
                                                   (name: "Red", type: .red),
                                                   (name: "Purple", type: .purple),
                                                   (name: "Orange", type: .orange),
                                                   (name: "Grey", type: .gray ),
                                                   (name:"Green", type: .green)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tutorialView.isHidden = true
        view.bringSubviewToFront(tutorialView)
        let gradient = CAGradientLayer()
        gradient.frame = tutorialView.bounds
        gradient.colors = [
            UIColor.init(white: 0, alpha: 0).cgColor,
            UIColor.black.cgColor,
            UIColor.black.cgColor
        ]
        tutorialView.backgroundColor = .clear
        tutorialView.layer.insertSublayer(gradient, at: 0)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        collectionView.performBatchUpdates(nil, completion: {
            (result) in
            if self.activeCell != nil {
                self.activeCell?.showInitialSwipeAnimations()
            }
        })
    }
    
    // This function will return dynamic list of buttons for each cell. We have limited to maximum number of 3 buttons ,however code will support any number of buttons for each card.
    
    func getButtonList(forIndex index : Int) -> [(name: String, type: ButtonType)] {
        var buttons: [(name: String, type: ButtonType)] = []
        let count = (index % 3) + 1
        let buttonList = [ButtonType.first, ButtonType.second, ButtonType.third]
        for index in 1...count {
            buttons.append((name: buttonList[index-1].rawValue, type: buttonList[index-1]))
        }
        return buttons
    }
    
    // MARK: Collection View Functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwipableCollectionViewCell", for: indexPath) as! SwipableCollectionViewCell
        cell.buttons = getButtonList(forIndex: indexPath.row)
        cell.setCardStyle(name: cards[indexPath.row].name, color: cards[indexPath.row].type)
        cell.delegate = self
        cell.clipsToBounds = false
        cell.tag = indexPath.row
        if indexPath.row == 0 {
            self.activeCell = cell
            self.activeCellIndex = 0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 60, bottom: 30, right: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        return CGSize(width: collectionViewWidth - 50, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    
    
    // MARK: SwipableCardButtonAction function
    
    func registerAction(forIdentifier iD: String) {
        let button : ButtonType = ButtonType(rawValue: iD) ?? ButtonType.first
        showButtonAction(forButton: button)
    }
    
    func registerSelection(forCell row: Int) {
        if row != activeCellIndex {
            let path = IndexPath(item: row, section: 0);
            let cell = collectionView.cellForItem(at: path)
            if let activeCell = activeCell {
                activeCell.resetCell()
            }
            self.activeCell = cell as? SwipableCollectionViewCell
            self.activeCellIndex = row
        }
    }
    
    func tutorialAnimationDidBegin() {
        UIView.animate(withDuration: 0.2) {
            self.tutorialView.isHidden = false
        }
    }
    
    func tutorialAnimationDidFinish() {
        UIView.animate(withDuration: 0.2) {
            self.tutorialView.isHidden = true
        }
    }
    
    
    func showButtonAction(forButton button : ButtonType) {
        
        let alert = UIAlertController(title: button.rawValue + " Action Done.", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

