//
//  ImageCacheService.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 27.08.24.
//

import Foundation

protocol IImageCacheService {
    func getImage(forKey key: String) -> Data?
    func setImage(_ imageData: Data, forKey key: String)
}

final class ImageCacheService: IImageCacheService {
    
    private let cache = NSCache<NSString, NSData>()
    
    func getImage(forKey key: String) -> Data? {
        return cache.object(forKey: key as NSString) as? Data
    }
    
    func setImage(_ imageData: Data, forKey key: String) {
        cache.setObject(imageData as NSData, forKey: key as NSString)
    }
}
