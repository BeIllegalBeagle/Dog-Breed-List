//
//  Dogs.swift
//  Breed List
//
//  Created by Peter Ajayi on 14/07/2020.
//  Copyright © 2020 Mito.P. All rights reserved.
//

import Foundation

struct Dogrequest: Codable {
    let message: [String: [String]]
    let status: String
}

struct DogList: Codable {
    
    var breed: String
    var subBreed: String?
    
    init(info: String, _ breedGroup: String? = nil) {
        breed = info
        subBreed = breedGroup
    }
    
    static func fromSubBreed(_ breeds: Dictionary<String, [String]>.Element) -> [DogList]{
        var list: [DogList] = []
        
        for type in breeds.value {
            list.append(DogList(info: "\(type)", breeds.key))
        }
        return list
    }
    
    func getBreed() -> String {

            if let subBrd = subBreed{
                return "\(subBrd)/\(breed)"
            } 

        else {
            return breed
        }
    }
    
}

struct DogImage: Codable {
    let message: String
    let status: String
}

struct DogImageArray: Codable {
    let message: [String]
    let status: String
}
