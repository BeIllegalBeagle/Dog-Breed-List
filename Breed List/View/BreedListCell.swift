//
//  BreedListCell.swift
//  Breed List
//
//  Created by Peter Ajayi on 14/07/2020.
//  Copyright © 2020 Mito.P. All rights reserved.
//

import UIKit

class BreedListCell: UICollectionViewCell {
    
    fileprivate var breedName: UILabel!
    fileprivate var previewImage: UIImageView!
    
    public var model: DogBreed? {
        didSet {
            breedName.text = model?.name
            previewImage.image = model?.image
        }
    }
    
    var transparantView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    fileprivate func setUpCellView() {
        addSubview(previewImage)
        previewImage.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(transparantView)
        transparantView.addSubview(breedName)
    }
    
    public func reset() {
        previewImage.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
