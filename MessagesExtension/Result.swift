//
//  Result.swift
//  bionic-app
//
//  Created by Vitaliy on 11/11/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import Foundation
import UIKit
import Messages

protocol ExecutionContext {
    
    var userIdentifier : UUID { get }
}

class Empty : Categories {
    
    init(userIdentifier: UUID)
    {
        super.init(code: "", type: "Empty", userIdentifier: userIdentifier)
    }
}

class Selection : Category {
    
    init(_ code: String)
    {
        super.init(type: Category.Result, code: code)
    }
}

class Result : Categories, ExecutionContext {
    
    init(userIdentifier: UUID, code: String)
    {
        super.init(code: code, type: "Result", userIdentifier: userIdentifier)
        super.categories = [ ]
    }
    
    // Selected categories
    init(userIdentifier: UUID, code: String, selectionCode: String)
    {
        super.init(code: code, type: "Result", userIdentifier: userIdentifier)
        super.categories = [ Selection(selectionCode) ]
    }
}


class FMKGameItem : Category {
    
    static let Fuck = "Fuck"
    static let Marry = "Marry"
    static let Kill = "Kill"
    
    var data : String?
    var imageUrl: String!
    
    init(_ code: String, imageUrl: String, data: String)
    {
        self.data = data
        self.imageUrl = imageUrl
        super.init(type: Category.FMKResult, code: code)
    }
}

class FMKGame : Categories, ExecutionContext {
    
    var gameIdentifier : UUID
    
    var respondents : [String] = []
    
    var title : String?

    init(userIdentifier: UUID, gameIdentifier: UUID, title: String?, code: String)
    {
        self.gameIdentifier = gameIdentifier
        self.title = title
        super.init(code: code, type: Categories.FMKResult, userIdentifier: userIdentifier)
        super.categories = [ ]
    }
    
    func getMarryKill() -> [FMKGameItem] {
        return self.categories
            .filter { (c: Category) -> Bool in
                if let g = c as? FMKGameItem, let r = g.data {
                    return r == FMKGameItem.Fuck || r == FMKGameItem.Marry
                }
                return false
            } as! [FMKGameItem]
    }
}

extension FMKGame {
    
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        
        items.append(URLQueryItem(name: "userIdentifier", value: userIdentifier.uuidString))
        items.append(URLQueryItem(name: "gameIdentifier", value: gameIdentifier.uuidString))
        items.append(URLQueryItem(name: "title", value: title))
        items.append(URLQueryItem(name: "code", value: code))
        items.append(URLQueryItem(name: "categories", value: categories.toJsonString()?.toBase64()))
        
        //print(self.toJsonString()!)
        return items
    }
    
    convenience init?(queryItems: [URLQueryItem]) {
        
        var gameIdOpt : UUID?
        var userIdentifierOpt : UUID?
        var imagesOpt : [Element]?
        var title : String?
        var code : String?
        
        for queryItem in queryItems {
            guard let value = queryItem.value else { continue }
            
            if let id = UUID(uuidString: value), queryItem.name == "userIdentifier" {
                userIdentifierOpt = id
            }
            if let id = UUID(uuidString: value), queryItem.name == "gameIdentifier" {
                gameIdOpt = id
            }
            if queryItem.name == "title" {
                title = value
            }
            if queryItem.name == "code" {
                code = value
            }
            if queryItem.name == "categories" {
                imagesOpt = Serializable.fromJson(jsonString: value.fromBase64()!, createFunction: Element.init(json:))
            }
        }
        
        //guard let game = gameIdOpt else { return nil }
        guard let userIdentifier = userIdentifierOpt else { return nil }
        guard let gameIdentifier = gameIdOpt else { return nil }
        guard let images = imagesOpt else { return nil }
        
        self.init(userIdentifier: userIdentifier, gameIdentifier: gameIdentifier, title: title!, code: code!)
        self.categories = images
    }
    
    convenience init?(message: MSMessage?) {
        guard let messageURL = message?.url else { return nil }
        guard let urlComponents = NSURLComponents(url: messageURL, resolvingAgainstBaseURL: false), let queryItems = urlComponents.queryItems else { return nil }
        
        self.init(queryItems: queryItems)
    }
}

extension FMKGame {
    // MARK: Computed properties
    
    
    func render() -> UIImage {
        
        let view = UIView()
        view.layer.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
        
        var images = self.getMarryKill()
        var frame : CGRect
        var imageView : UIImageView
        
        if images.count > 0 {
            frame = CGRect(x: 0, y: 0, width: 250, height: 250)
            imageView = UIImageView(frame: frame)
            imageView.showImage(imageUrl: images[0].imageUrl, sync: true)
            view.addSubview(imageView)
        }
        
        if images.count > 1 {
            frame = CGRect(x: 250, y: 0, width: 250, height: 250)
            imageView = UIImageView(frame: frame)
            imageView.showImage(imageUrl: images[1].imageUrl, sync: true)
            view.addSubview(imageView)
        }
        
        if images.count > 2 {
            frame = CGRect(x: 0, y: 250, width: 250, height: 250)
            imageView = UIImageView(frame: frame)
            imageView.showImage(imageUrl: images[2].imageUrl, sync: true)
            view.addSubview(imageView)
        }
        
        if images.count > 3 {
            frame = CGRect(x: 250, y: 250, width: 250, height: 250)
            imageView = UIImageView(frame: frame)
            imageView.showImage(imageUrl: images[3].imageUrl, sync: true)
            view.addSubview(imageView)
        }
        
        return UIImage(view: view)
    }
}



