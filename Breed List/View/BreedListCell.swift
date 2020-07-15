//
//  BreedListCell.swift
//  Breed List
//
//  Created by Peter Ajayi on 14/07/2020.
//  Copyright © 2020 Mito.P. All rights reserved.
//

import UIKit
import SkeletonView

class BreedListCell: UICollectionViewCell {
    
    public var inRandomView: Bool = false
    
    fileprivate var breedName: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
       return lbl
    }()
    
    fileprivate var previewImage: DogImageView = {
        let image = DogImageView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        return image
    }()
    
    public var model: DogBreed? {
        didSet {
         
            setInfoVisible()
            
            previewImage.imageURL = model?.imageUrl
            previewImage.loadFromURL(urlString: (model?.imageUrl)!)
            self.stopSkeletonAnimation()
            self.hideSkeleton()
        }
    }
    
    fileprivate func setInfoVisible() {
        if inRandomView {
            transparantView.isHidden = true
            breedName.isHidden = true
        }
        else {
            if let dom  = model?.domBreed {
                breedName.text = "\(model?.name ?? "") \(dom)"
            }
            else {
                breedName.text = (model?.name)
            }
        }
    }
    
    fileprivate var transparantView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.opacity = 0.5
        view.layer.backgroundColor = UIColor.darkGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate func setUpCellView() {
        
        addSubview(previewImage)
        previewImage.translatesAutoresizingMaskIntoConstraints = false
        previewImage.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        previewImage.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        previewImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        previewImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        addSubview(transparantView)
        transparantView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        transparantView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        transparantView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        transparantView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        addSubview(breedName)
        breedName.translatesAutoresizingMaskIntoConstraints = false
        breedName.rightAnchor.constraint(equalTo: transparantView.rightAnchor, constant: -5).isActive = true
        breedName.bottomAnchor.constraint(equalTo: transparantView.bottomAnchor).isActive = true
        breedName.leftAnchor.constraint(equalTo: transparantView.leftAnchor, constant: 5).isActive = true
        breedName.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    public func reset() {
        previewImage.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setUpCellView()
        layer.cornerRadius = 15
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
