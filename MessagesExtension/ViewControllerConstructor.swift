//
//  ViewControllerConstructor.swift
//  bionic-apps
//
//  Created by Vitaliy on 10/25/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import Foundation
import UIKit

enum QuestionType {
    case QuestionList
    case Marry
    case Kill
    
    static var queryItemKey: String {
        return "FMK"
    }
}

/*
class Schema {

    var title: String
    var backgroundImage: String
    var nextButtonTitle: String
}

class Question {
    
    var code: UUID
    var imageUrl: String!
    var imageText: String
}

class QuestionListSchema : Schema {
    
    var questions: [Question]
}*/





/*
class CustomViewController : UIViewController {

    var schema: Schema!
    
    var delegate: CustomViewControllerDelegate!

    func validate () -> Bool {
        preconditionFailure("The method must be overriden")
    }
    
    func context () -> ExecutionContext {
        preconditionFailure("The method must be overriden")
    }
    
    func next() {
        
        if (self.validate())
        {
             delegate?.doNextStep(self.context())
        }
        else
        {
            // show warning to select anything
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}


protocol ViewControllerConstructor {

    func Build(schema: Schema) -> CustomViewController
}

class QuestionListViewControllerConstructor : ViewControllerConstructor {
    
    
    func Build(schema: Schema) -> CustomViewController {
        if let schema = schema as? QuestionListSchema {
            var result = UIViewController()
            
            
            let lable = UILabel()
            
            result.view.addSubview()
            
            addChildViewController(controller)
            
            controller.view.frame = view.bounds
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(controller.view)
            
            controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            
            controller.view.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        }
    }
    
}*/
