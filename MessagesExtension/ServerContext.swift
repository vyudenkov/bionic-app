//
//  ServerContext.swift
//  bionic-apps
//
//  Created by Vitaliy on 10/28/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import Foundation

protocol Category {
    var code : String { get }
}

protocol Categories {
    
    var userIdentifier : UUID { get }
    // category type - the kind of question: school selection, etc
    // TODO: if static - make enum
    // on server - identify how to process received from client result
    // on client - identify how to represent the data
    var type : String { get }
    
    var categories : [Category] { get }
    
    // This is the result which is sent to server
    //var selectedCategories : [Category] { get }
}

protocol ExecutionContext {
    
}

class Selection : Category {

    var code : String
    
    required init(_ code: String) {
        self.code = code
    }
}

class Result : Serializable, ExecutionContext, Categories {
    
    var userIdentifier: UUID
    
    var type : String = "Result"
    
    // Selected categories
    var categories : [Category] = []
    
    init(userIdentifier: UUID, selectionCode: String)
    {
        self.userIdentifier = userIdentifier
        self.categories = [ Selection(selectionCode) ]
    }
}

class Question : Category {

    var code: String
    var imageText: String
    var imageUrl: String
    
    init(code: String, imageText: String, imageUrl: String)
    {
        self.code = code
        self.imageText = imageText
        self.imageUrl = imageUrl
    }
}

class Questions : Categories {
    
    var userIdentifier: UUID
    
    // identify game session
    var sessionIdentifier: UUID
    
    var type = "Question"
    
    var title: String?
    
    var buttonText: String?
    
    var questions : [Question] {
        get {
            return categories.flatMap({$0 as? Question})
        }
    }
    
    var categories : [Category] = []
    
    init(userIdentifier: UUID, sessionIdentifier: UUID, title: String?, buttonText: String?) {
        self.userIdentifier = userIdentifier
        self.sessionIdentifier = sessionIdentifier
        self.title = title
        self.buttonText = buttonText
    }
    
    static func fromJson(json: Dictionary<String, Any>) -> Questions {
        
        let userIdentifier = UUID(uuidString: (json["userIdentifier"] as? String)!)
        let sessionIdentifier = UUID(uuidString: (json["sessionIdentifier"] as? String)!)
        let title = json["title"] as? String
        let buttonText = json["buttonText"] as? String

        let result = Questions(userIdentifier: userIdentifier!, sessionIdentifier: sessionIdentifier!, title: title, buttonText: buttonText)
        
        let questions = json["categories"] as! [Dictionary<String, Any>]
        for question in questions {
            let code = question["code"] as? String
            let imageText = question["imageText"] as? String
            let imageUrl = question["imageUrl"] as? String
            
            result.categories.append(Question(code: code!, imageText: imageText!, imageUrl: imageUrl!))
        }
        return result
    }
}


class ServerContext : Serializable {
    
    var imageId: UUID?
    
    var imageUrl: String?

}
