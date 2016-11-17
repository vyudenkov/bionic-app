//
//  FMKGame.swift
//  bionic-apps
//
//  Created by Vitaliy on 10/17/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import Foundation
import UIKit
import Messages


enum FMK : String, Setting, QueryItemRepresentable {
    case Fuck
    case Marry
    case Kill
    
    static var queryItemKey: String {
        return "FMK"
    }
}

class GameImage : Serializable {

    var imageId: UUID
    
    var imageUrl: String
    
    init(imageId: UUID, imageUrl: String)
    {
        self.imageId = imageId
        self.imageUrl = imageUrl
    }
    
    init(jsonStr: String)
    {
        self.imageId = UUID()
        self.imageUrl = ""
        super.init()

        Serializable.initialize(obj: self, jsonString: jsonStr)
    }
    
    init?(json: Dictionary<String, Any>)
    {
        var imageId : UUID?
        var imageUrl : String?
        for (key, value) in json {
            if key == "imageId" {
                imageId = UUID(uuidString: value as! String)!
            }
            else if key == "imageUrl" {
                imageUrl = value as? String
            }
        }
        if let imageId = imageId, let imageUrl = imageUrl {
            self.imageId = imageId
            self.imageUrl = imageUrl
        }
        else {
            return nil
        }
    }
    
    private static func create (dict: Dictionary<String, Any>) -> GameImage {
        return GameImage(json: dict)!
    }
    
    static func fromJson(jsonString: String) -> GameImage {
        return Serializable.fromJson(jsonString: jsonString, createFunction: create)!
    }
    

    func showInView(imageView: UIImageView) {
        imageView.image = nil
        /*if let url = URL(string: self.imageUrl), let data = try? Data(contentsOf: url) {
            imageView.image = UIImage(data: data)
        }*/
        //imageView.image = URL(string: self.imageUrl).flatMap { try? Data(contentsOf: $0) }.flatMap{ UIImage(data: $0) }
        // Suggested async image loading
        if let url = URL(string: self.imageUrl) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data!)
                }
            }
        }
    }

    static func empty() -> GameImage {
        return GameImage(imageId: UUID(), imageUrl: "")
    }
    
    func toString() -> String {
        return (self.imageId.uuidString + "," + self.imageUrl).toBase64()
    }
    
    static func fromString(base64: String) -> GameImage? {
        if let str = base64.fromBase64() {
            let c = str.characters
            if let comma = c.index(of: ",") {
                let imageId = str[str.startIndex..<comma]
                let imageUrl = str[comma..<str.endIndex]
                return GameImage(imageId: UUID(uuidString: imageId)!, imageUrl: imageUrl)
            }
            return nil
        }
        return nil
    }
}

// a single respondent response to the single image
class GameImageResponse: GameImage {

    var response: FMK?
    
    init(image: GameImage, response: FMK? = nil)
    {
        super.init(imageId: image.imageId, imageUrl: image.imageUrl)
        self.response = response
    }
}

class Respondent : Serializable {
    
    var respondentId: UUID
    
    init(respondentId: UUID)
    {
        self.respondentId = respondentId
    }
    
    init?(json: Dictionary<String, Any>)
    {
        var respondentId : UUID?
        for (key, value) in json {
            if key == "respondentId" {
                respondentId = UUID(uuidString: value as! String)!
            }
        }
        if let respondentId = respondentId {
            self.respondentId = respondentId
        }
        else {
            return nil
        }
    }
    
    func toString() -> String {
        return self.respondentId.uuidString.toBase64()
    }
    
    static func fromString(base64: String) -> Respondent? {
        if let str = base64.fromBase64() {
            return Respondent(respondentId: UUID(uuidString: str)!)
        }
        return nil
    }
    
    private static func create(dict: Dictionary<String, Any>) -> Respondent {
        
        return Respondent(json: dict)!
    }
    
    static func fromJson(jsonString: String) -> Respondent {
        return Serializable.fromJson(jsonString: jsonString, createFunction: create)!
    }
}

class RespondentResponses : Respondent {
    
    fileprivate var responses: [GameImageResponse]
    
    init(respondent: Respondent, responses: [GameImageResponse]) {
        
        self.responses = responses
        super.init(respondentId: respondent.respondentId)
        
    }
}

/**
 Extends `Respondent` to make it `Equatable`.
 */
extension Respondent {

    static func ==(lhs: Respondent, rhs: Respondent) -> Bool {
        return lhs.respondentId == rhs.respondentId
    }
}

class GameResponses {

    fileprivate var responses: [RespondentResponses]

    init(responses: [RespondentResponses]) {
        self.responses = responses
    }
    
    func append(_ respondent: RespondentResponses) {
        /*
         Filter any existing instances of the new ice cream from the current
         history before adding it to the end of the history.
         */
        var newIceCreams = self.responses.filter { $0 != respondent }
        newIceCreams.append(respondent)
        
        responses = newIceCreams
    }
}


class FMKGameRequest : Serializable {
    
    var gameId: UUID
    
    var images: [GameImage]
    
    var senderId: UUID
    
    var respondents: [Respondent]
    
    init(gameId: UUID, images: [GameImage], senderId: UUID, respondents: [Respondent]) {
        self.gameId = gameId
        self.senderId = senderId
        self.images = images
        self.respondents = respondents
    }
}

/**
 Extends `FMKGameRequest` to be able to be represented by and created with an array of
 `NSURLQueryItem`s.
 */
extension FMKGameRequest {
    // MARK: Computed properties
       
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        
        items.append(URLQueryItem(name: "gameId", value: gameId.uuidString))
        items.append(URLQueryItem(name: "senderId", value: senderId.uuidString))
        items.append(URLQueryItem(name: "images", value: images.toJsonString()?.toBase64()))
        items.append(URLQueryItem(name: "respondents", value: respondents.toJsonString()?.toBase64()))
        
        print(self.toJsonString()!)
        return items
    }
    
    // MARK: Initialization
    
    convenience init?(queryItems: [URLQueryItem]) {
        
        var gameIdOpt : UUID?
        var senderIdOpt : UUID?
        var imagesOpt : [GameImage]?
        var respondentsOpt : [Respondent]?
        for queryItem in queryItems {
            guard let value = queryItem.value else { continue }
            
            if let id = UUID(uuidString: value), queryItem.name == "gameId" {
                gameIdOpt = id
            }
            if let id = UUID(uuidString: value), queryItem.name == "senderId" {
                senderIdOpt = id
            }
            if queryItem.name == "images" {
                
                imagesOpt = Serializable.fromJson(jsonString: value.fromBase64()!, createFunction: GameImage.init)
            }
            if queryItem.name == "respondents" {
                
                respondentsOpt = Serializable.fromJson(jsonString: value.fromBase64()!, createFunction: Respondent.init(json:))
            }
        }
        
        guard let game = gameIdOpt else { return nil }
        guard let sender = senderIdOpt else { return nil }
        guard let images = imagesOpt else { return nil }
        guard let respondents = respondentsOpt else { return nil }
        
        self.init(gameId: game, images: images, senderId: sender, respondents: respondents)
    }
    
    convenience init?(message: MSMessage?) {
        guard let messageURL = message?.url else { return nil }
        guard let urlComponents = NSURLComponents(url: messageURL, resolvingAgainstBaseURL: false), let queryItems = urlComponents.queryItems else { return nil }
        
        self.init(queryItems: queryItems)
    }
}


extension FMKGameRequest {
    // MARK: Computed properties
    
    func render() -> UIImage {
        
        return #imageLiteral(resourceName: "MessageImage")
    }
}



enum ApplicationState {
    case intro
    case fmkGame(FMKGameRequest)
}

