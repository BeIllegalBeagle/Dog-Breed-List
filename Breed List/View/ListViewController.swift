//
//  ViewController.swift
//  Breed List
//
//  Created by Peter Ajayi on 14/07/2020.
//  Copyright © 2020 Mito.P. All rights reserved.
//

import UIKit
import SkeletonView


protocol retriveURLDelegate {
   func retriveDogURLs(dogBreed: String, com: @escaping ([String]) -> ())
}

enum states {
    case noSearchResults, noInternet
}

class ListViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, retriveURLDelegate, UISearchBarDelegate {

    fileprivate let networkHandler = NetworkRequester()
    
    fileprivate let cellId = "dogBreedCell"
    fileprivate let headerId = "headerCellId"
    fileprivate var breedList: [DogList] = []
    fileprivate var tempViewModel: [DogBreed] = []
    fileprivate var viewModel: [DogBreed] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    fileprivate lazy var noResults: UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        lbl.numberOfLines = 3
        return lbl
    }()
    
    fileprivate var internetError: Bool = false
    
    fileprivate let searchBar: UISearchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    fileprivate func setUpSearchController() {
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = "Search Doggies"
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.tintColor = .blue
        searchBar.returnKeyType = UIReturnKeyType.search
        hideKeyboardWhenTappedAroundd()
    }
    
    fileprivate func setUpCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        collectionView.backgroundColor = .white
        self.collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        self.collectionView.register(BreedListCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    fileprivate func setUp() {
        //Netoworking
        getDogNames()
        //Collection View
        setUpCollectionView()
        //SearchBar
        setUpSearchController()
    }
    
    fileprivate func setEmptyState(_ type: states) {
        collectionView.addSubview(noResults)
        noResults.translatesAutoresizingMaskIntoConstraints = false
        noResults.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        noResults.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        let screenSize = UIScreen.main.bounds
        noResults.widthAnchor.constraint(equalToConstant: screenSize.width * 0.7).isActive = true
        noResults.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        switch type {
        case .noInternet:
            noResults.text = "Error fetching doggies 🦴"
            internetError = true
            collectionView.reloadData()
        case .noSearchResults:
            noResults.text = "No doggies found 🕵️‍♂️"
            print("state no no search results set")
            
        }
    }
    
    fileprivate func getDogNames() {
        networkHandler.fetchAllBreedsList { (result, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    self.setEmptyState(.noInternet)
                }
                return
            }
            
            if let requestResult = result {
                let standAloneBreeds = requestResult.message.filter() {$0.value.isEmpty}
                let subBreeds = requestResult.message.filter() {!$0.value.isEmpty}
              
                DispatchQueue.main.async {
                      for breed in standAloneBreeds {
                          self.breedList.append(DogList(info: breed.key))
                      }
                      
                      for subBreed in subBreeds {
                          self.breedList.append(contentsOf: DogList.fromSubBreed(subBreed))
                      }
                    
                    self.getDogImages()

                }
            }
          }
    }
    
    //turn model into view model
    //get the dogs url and add it to the VM object
    fileprivate func getDogImages() {
        networkHandler.getImageURLs(breedList) { vm in
            self.viewModel = vm
        }
    }
    
    public func retriveDogURLs(dogBreed: String, com: @escaping ([String]) -> ()) {
        
        networkHandler.getRandomDogs(dogBreed) { urls in
            DispatchQueue.main.async {
                com(urls)
            }
        }
        
    }
    
    //MARK: - SEARCH
 
    private func hideKeyboardWhenTappedAroundd() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboardd))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
       
    @objc func dismissKeyboardd() {
        view.endEditing(true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if tempViewModel.isEmpty {
            noResults.removeFromSuperview()
        }
        return true
    }
    
    func searchBarIsEmpty() -> Bool {
          // Returns true if the text is empty or nil
           return searchBar.text?.isEmpty ?? true
       }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            filterContentForSearchText(searchBar.text!.lowercased())
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            tempViewModel = []
            collectionView.reloadData()
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        tempViewModel = viewModel.filter({( canine : DogBreed) -> Bool in
            return "\(canine.name) \(canine.domBreed ?? "")".lowercased().contains(searchText.lowercased())
        })
        
        collectionView.reloadData()
        
    }
    
    //MARK: - COLLECTIONVIEW
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
        header.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.leftAnchor.constraint(equalTo: header.leftAnchor).isActive = true
        searchBar.rightAnchor.constraint(equalTo: header.rightAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: header.topAnchor).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if internetError {
            return 0
        }
        else if viewModel.isEmpty {
            return 8
        }
        else {
            
            if searchBarIsEmpty() {
                return viewModel.count
            }
            else {
                tempViewModel.isEmpty
                    ? setEmptyState(.noSearchResults)
                    : nil
                return tempViewModel.count
            }

        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! BreedListCell
        cell.isSkeletonable = true
        cell.showAnimatedGradientSkeleton() //.showAnimatedSkeleton()
        
        cell.reset()
        
        let currentVM = searchBarIsEmpty()
            ? viewModel
            : tempViewModel
        
        if !currentVM.isEmpty {
            cell.model = currentVM[indexPath.row]
        }
    
        return cell
    }
        
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           
        guard !viewModel.isEmpty else { return }
        let currentVM = searchBarIsEmpty()
           ? viewModel
           : tempViewModel
        
        let dogInfo = currentVM[indexPath.row]
        let vc = DogDetailViewController()
        vc.dogBreed = {
            if let domBrd = dogInfo.domBreed {
                return "\(domBrd)/\(dogInfo.name)"
            } else {
                return dogInfo.name
            }
        }()
        vc.delegate = self
        vc.view.backgroundColor = .white
        navigationController?.pushViewController(vc, animated: true)
           
    }
}
