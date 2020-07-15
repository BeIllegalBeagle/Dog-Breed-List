//
//  DogDetailViewController.swift
//  Breed List
//
//  Created by Peter Ajayi on 14/07/2020.
//  Copyright © 2020 Mito.P. All rights reserved.
//

import UIKit

class roundedButton: UIButton {
    
    override var isHighlighted: Bool {
            
        didSet {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                 self.alpha = self.isHighlighted ? 0.5 : 1
            }, completion: nil)
        }
    }
    
}

class DogDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    public var dogBreed: String?
    public var delegate: retriveURLDelegate?
    
    fileprivate var urls: [String] = [] {
        didSet {
            randomDogCollectionView?.reloadData()
        }
    }
    
    fileprivate let cellId = "breedCell"
    fileprivate var randomDogCollectionView: UICollectionView?
    
    fileprivate let collectionContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    fileprivate let randomButton: roundedButton = {
        
        let i = roundedButton(frame: CGRect(x: 0, y: 0, width: 150, height: 100))
        i.layer.cornerRadius = 15
        i.backgroundColor = .belizeHole
        i.setTitle("Shuffle 🔀", for: .normal)
        i.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return i
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = dogBreed
        setUpBtn()
        setUpCollection()
        getImageUrls()
    }
    
    func getImageUrls() {
        if let dogBrd = dogBreed {
            delegate?.retriveDogURLs(dogBreed: dogBrd) { urls in
                self.urls = urls
            }
        }
    }
    
    fileprivate func setUpCollection() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 150)
        
        let collectionFrame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 20, height: 250)
        randomDogCollectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
        randomDogCollectionView?.register(BreedListCell.self, forCellWithReuseIdentifier: cellId)
        randomDogCollectionView?.delegate = self
        randomDogCollectionView?.dataSource = self
        randomDogCollectionView?.layer.cornerRadius = 15
        randomDogCollectionView?.backgroundColor = .clouds
        
        view.addSubview(collectionContainer)
        collectionContainer.translatesAutoresizingMaskIntoConstraints = false
        collectionContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        collectionContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        collectionContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        collectionContainer.bottomAnchor.constraint(equalTo: randomButton.topAnchor, constant: -15).isActive = true
        
        collectionContainer.addSubview(randomDogCollectionView!)
        randomDogCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        randomDogCollectionView?.leftAnchor.constraint(equalTo: collectionContainer.leftAnchor).isActive = true
        randomDogCollectionView?.rightAnchor.constraint(equalTo: collectionContainer.rightAnchor).isActive = true
        randomDogCollectionView?.topAnchor.constraint(equalTo: collectionContainer.topAnchor, constant: 10).isActive = true
        randomDogCollectionView?.bottomAnchor.constraint(equalTo: collectionContainer.bottomAnchor, constant: -10).isActive = true
        
    }
    
    fileprivate func setUpBtn() {
        view.addSubview(randomButton)
        randomButton.addTarget(self, action: #selector(randomBtnPressed), for: .touchUpInside)
        randomButton.translatesAutoresizingMaskIntoConstraints = false
        randomButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        randomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        randomButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        randomButton.widthAnchor.constraint(equalToConstant: 170).isActive = true

    }
    
    @objc func randomBtnPressed() {
        urls = []
        getImageUrls()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if urls.isEmpty {
          return 10
        }
        else {
            return urls.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! BreedListCell
        cell.isSkeletonable = true
        cell.showAnimatedGradientSkeleton() //.showAnimatedSkeleton()
        cell.inRandomView = true
        
        cell.reset()
            
        if !urls.isEmpty {
            cell.model = DogBreed(name: "", image: urls[indexPath.row])
        }

        return cell
    }
}
