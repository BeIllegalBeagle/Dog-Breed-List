//
//  DogBreed.swift
//  Breed List
//
//  Created by Peter Ajayi on 14/07/2020.
//  Copyright © 2020 Mito.P. All rights reserved.
//

import UIKit

struct DogBreed {
    
    var domBreed: String?
    var name: String
    var imageUrl: String? //if this is nil, then the image is cached
    
    init(name:String, _ dominateBreed: String? = nil, image: String?) {
        self.name = name
        self.domBreed = dominateBreed
        self.imageUrl = image
    }
}
