//
//  UrlSettings.swift
//  bionic-app
//
//  Created by Vitaliy on 10/31/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import Foundation

//import UIKit
//import Messages

protocol Setting {
    var rawValue: String { get }
    
}

protocol QueryItemRepresentable {
    var queryItem: URLQueryItem { get }
    
    static var queryItemKey: String { get }
}

extension QueryItemRepresentable where Self: Setting {
    var queryItem: URLQueryItem {
        return URLQueryItem(name: Self.queryItemKey, value: rawValue)
    }
}
