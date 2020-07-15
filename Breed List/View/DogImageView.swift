//
//  DogImageView.swift
//  Breed List
//
//  Created by Peter Ajayi on 14/07/2020.
//  Copyright © 2020 Mito.P. All rights reserved.
//

import UIKit

class DogImageView: UIImageView {

    var imageURL: String?
    
    func loadFromURL(urlString: String) {
        imageURL = urlString
        
        image = nil
//        if let imageCache = imageCache.
        guard let url = URL(string: urlString) else {
                   fatalError()
        }
        
        let urlRequest = URLRequest(url: url)

        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            guard let data = data else { return }

            DispatchQueue.main.async {
            
                let imageToCache = UIImage(data: data)
                
                if self.imageURL == urlString {
                    self.image = imageToCache
                    self.layer.cornerRadius = 15
                    self.clipsToBounds = true
                }
            }
        }.resume()
    }

}
