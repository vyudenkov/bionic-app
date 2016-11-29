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

extension UIImage {

    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage!)!)
    }
}

extension UIImageView {

    func showImage(imageUrl: String, sync: Bool = false) {
        
        self.image = nil
        
        if sync {
            if let url = URL(string: imageUrl), let data = try? Data(contentsOf: url) {
                self.image = UIImage(data: data)
            }
        } else {
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

extension NSLayoutConstraint {

    override open var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant:\(constant)"
    }
}
