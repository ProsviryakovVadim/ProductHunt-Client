//
//  ProductApi.swift
//  ProductHuntClient
//
//  Created by Vadim on 7/7/17.
//  Copyright © 2017 Vadim Prosviryakov. All rights reserved.
//

import Alamofire
import RxSwift
import SDWebImage

typealias Parameters = Alamofire.Parameters

class ProductApi {
    
    static let instance = ProductApi()
    private let access_token = "591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff"
    private let url = "https://api.producthunt.com/v1"
    
    private func getProduct(category: String, accessToken: String) -> URL? {
        return URL(string: url + "/categories/\(category)/posts?access_token=\(accessToken)")
    }
    
    private func getCategory(accessToken: String) -> URL? {
        return URL(string: url + "/categories?access_token=\(accessToken)")
    }
    
    let params: Parameters = [
        "Content-Type": "application/json",
        "Host": "https",
        "Connection": "close"
    ]
    
    func getProducts(category: String) -> Observable<[Product]> {
        return Observable.create({ (observer) -> Disposable in
            let req = Alamofire.request(self.getProduct(category: category.localizedLowercase, accessToken: self.access_token)!, parameters: self.params).responseObject {(response: DataResponse<Posts>) in
                switch response.result {
                case .success(let res):
                    observer.onNext(res.posts)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                req.cancel()
            }
        })
    }
    
    // TODO...
    func getCategory() -> Observable<[Category]> {
        return Observable.create({ (observer) -> Disposable in
            let req = Alamofire.request(self.getCategory(accessToken: self.access_token)!, parameters: self.params).responseObject {(response: DataResponse<Categories>) in
                switch response.result {
                case .success(let res):
                    observer.onNext(res.category)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                req.cancel()
            }
        })
    }
    
    // MARK: - Image download
    func loadImageFromUrl(_ url: NSURL, closure: @escaping (UIImage?, NSError?) -> Void) {
        SDWebImageManager.shared().loadImage(with: url as URL!, options: .cacheMemoryOnly, progress: nil) { (image, data, error, cache, finished, withUrl) in
            if ((image != nil) && finished) {
                closure(image, error as NSError?)
            }
        }
    }
}
