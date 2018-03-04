//
//  Extensions.swift
//  HomeBand
//
//  Created by Nicolas Gérard on 3/03/18.
//  Copyright © 2018 HEH. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage



extension UIImage{
    
    convenience init(url:String){
        Alamofire.request(url, method: .get).responseImage{ response in
            if(response.result.isSuccess){
                if let image = response.result.value {
                    self image
                }
            }
        }
        
        let image = UIImage(
    }
    
    func fromUrl(url:URL!) -> UIImage{
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            
            }.resume()
    }
    
    func fromUrl(url:String!) -> UIImage{
        let myUrl:URL = URL(string: url)!
        return fromUrl(url: myUrl)
    }
    
    
}
