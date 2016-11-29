//
//  BaseQuestionViewController.swift
//  bionic-app
//
//  Created by Vitaliy on 11/1/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

protocol SaveResponseControllerDelegate: class {
    func saveSchema(_ response: Result)
}


class BaseSchemaViewController: BaseViewController {

    var schema: Schema!
    
    var delegate: SaveResponseControllerDelegate!
    
    func next() {
        if (validate()) {
            doAction(context: context())
        }
        else
        {
            // show warning to select anything
            self.showWarning()
        }
    }
    
    func doAction(context: Result) {
        self.delegate.saveSchema(context)
    }
    
    func validate () -> Bool {
        preconditionFailure("The method must be overriden")
    }
    
    func context () -> Result {
        preconditionFailure("The method must be overriden")
    }
}
