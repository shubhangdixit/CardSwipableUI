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

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cards : [(name: String, type: UIColor)] = [(name:"Blue", type:.blue),
                                       (name: "Red", type: .red),
                                       (name: "Purple", type: .purple),
                                       (name: "Yellow", type: .yellow),
                                       (name: "Grey", type: .gray ),
                                       (name:"Green", type: .green)]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func getButtonList() -> [(name: String, type: ButtonType)] {
        var buttons: [(name: String, type: ButtonType)] = []
        let count = Int.random(in: 1...3)
        let buttonList = [ButtonType.first, ButtonType.second, ButtonType.third]
        for index in 1...count {
            buttons.append((name: buttonList[index-1].rawValue, type: buttonList[index-1]))
        }
        return buttons
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwipableCollectionViewCell", for: indexPath) as! SwipableCollectionViewCell
        cell.buttons = getButtonList()
        cell.setCardStyle(name: cards[indexPath.row].name, color: cards[indexPath.row].type)
        cell.clipsToBounds = false
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
}

