//
//  ManagerProtocol.swift
//  Breed List
//
//  Created by Peter Ajayi on 14/07/2020.
//  Copyright © 2020 Mito.P. All rights reserved.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchAllBreedsList(completion: @escaping (Dogrequest?, states?) -> ())
    func getImageURLs(_ breedList: [DogList], completion: @escaping ([DogBreed]) -> ())
    func getRandomDogs(_ dogBreed: String, completion: @escaping ([String]) -> ())
}
