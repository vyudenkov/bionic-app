//
//  Extensions.swift
//  bionic-apps
//
//  Created by Vitaliy on 10/19/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import Foundation
import UIKit


extension String {

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

extension Mirror {
    
    func toDictionary(withSuperClass: Bool = true) -> [String: Any] {
    
        var dict = [String: Any]()
        
        for attr in self.children {
            if let propertyName = attr.label {
                dict[propertyName] = attr.value
            }
        }
        if let parent = self.superclassMirror {
            for (propertyName, value) in parent.toDictionary() {
                dict[propertyName] = value
            }
        }
        return dict
    }
}

extension UIImageView {

    func showImage(imageUrl: String) {
        
        self.image = nil
        /*if let url = URL(string: self.imageUrl), let data = try? Data(contentsOf: url) {
         imageView.image = UIImage(data: data)
         }*/
        //imageView.image = URL(string: self.imageUrl).flatMap { try? Data(contentsOf: $0) }.flatMap{ UIImage(data: $0) }
        // Suggested async image loading
        if let url = URL(string: imageUrl) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
            }
        }
    }
}

extension UIButton {
    
    func showImage(imageUrl: String) {
        /*if let url = URL(string: imageUrl), let data = try? Data(contentsOf: url) {
            self.setImage(UIImage(data: data), for: UIControlState.normal)
        }*/
        if let url = URL(string: imageUrl) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.setImage(UIImage(data: data!), for: UIControlState.normal)
                }
            }
        }
    }
}
