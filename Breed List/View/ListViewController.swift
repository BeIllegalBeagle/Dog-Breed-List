//
//  ViewController.swift
//  Breed List
//
//  Created by Peter Ajayi on 14/07/2020.
//  Copyright © 2020 Mito.P. All rights reserved.
//

import UIKit

class ListViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    fileprivate let cellId = "dogBreedCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    fileprivate func setUp() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
//        self.collectionView.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellWithReuseIdentifier: <#T##String#>)
    }
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//            return SuggestedCells.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "suggestedCell", for: indexPath as IndexPath) as! SuggestedCellCollectionViewCell
//           cell.contentView.superview?.clipsToBounds = true
//           cell.reset()
//
//           let state: cellStates = SuggestedCells[indexPath.row].isImmortal
//               ? .immortal
//               : .alive
//
//           cell.model = CellPreviewModel(name: SuggestedCells[indexPath.row].name, CHX: String(SuggestedCells[indexPath.row].chx_count), _id: SuggestedCells[indexPath.row]._id, xrb_address: SuggestedCells[indexPath.row].xrb_address, remainingTime: SuggestedCells[indexPath.row].progress, state: state, numberOfUsersInCell: SuggestedCells[indexPath.row].numberOfMitos)
//
//           return cell
//        }
        
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           
//           let cell = SuggestedCells[indexPath.row]
           
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt: IndexPath) -> CGSize {
            return CGSize(width: 140, height: 100)
    }
}

extension ListViewController {
    
}
