//
//  NetworkRequester.swift
//  Breed List
//
//  Created by Peter Ajayi on 14/07/2020.
//  Copyright © 2020 Mito.P. All rights reserved.
//

import Foundation

class NetworkRequester: NetworkManagerProtocol {
    
    final let _CORE_API_URL: String = "https://dog.ceo/api"
    
    func getRandomDogs(_ dogBreed: String, completion: @escaping ([String]) -> ()) {
        let _URL = "\(_CORE_API_URL)/breed/\(dogBreed)/images/random/10"
        guard let url = URL(string: _URL) else {
            fatalError()
        }
        
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decodedReponse = try JSONDecoder().decode(DogImageArray.self, from: data)
                completion(decodedReponse.message)
            } catch {
                print(error)
            }
                      
      }.resume()
                  
              
    }
    
    func fetchAllBreedsList(completion: @escaping (Dogrequest?, states?) -> ()) {
        let _URL = "\(_CORE_API_URL)/breeds/list/all"
        
        guard let url = URL(string: _URL) else {
            fatalError()
        }
        
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                completion(nil, .noInternet)
            }
            guard let data = data else { return }
            
            do {
                let breedList = try JSONDecoder().decode(Dogrequest.self, from: data)
                completion(breedList, nil)
            } catch {
                print(error)
            }
                        
        }.resume()
    }
    
    //'beagle' for stand-alone
    //'sub/bealge for sub-breeds'
    func getImageURLs(_ breedList: [DogList], completion: @escaping ([DogBreed]) -> ()) {
        var vm: [DogBreed] = []
        for dogName in breedList {

            let _URL = "\(_CORE_API_URL)/breed/\(dogName.getBreed())/images/random"
            guard let url = URL(string: _URL) else {
                fatalError()
            }
            
            let urlRequest = URLRequest(url: url)
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let imageURL = try JSONDecoder().decode(DogImage.self, from: data)
                    
                    DispatchQueue.main.async {
                        vm.append(DogBreed(name: dogName.breed, dogName.subBreed, image: imageURL.message))
                        if vm.count == breedList.count {
                            completion(vm)
                        }
                    }
                    
                } catch {
                    print(error)
                    
                }
                            
            }.resume()
            
        }
        
    }
    
}
//https://dog.ceo/api/breed/hound/images/random
//https://dog.ceo/api/breed/hound/afghan/images/random

//https://dog.ceo/api/breed/hound/afghan/images/random/3
//https://dog.ceo/api/breed/beagle/images/random/3
