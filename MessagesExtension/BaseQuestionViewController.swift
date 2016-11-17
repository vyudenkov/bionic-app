//
//  BaseQuestionViewController.swift
//  bionic-app
//
//  Created by Vitaliy on 11/1/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

class BaseQuestionViewController: BaseViewController {

    var schema: Schema!
    
    var delegate: CustomViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    func next() {
        if (validate()) {
            doAction(context: context())
        }
        else
        {
            // show warning to select anything
            super.showWarning()
        }
    }
    
    func doAction(context: ExecutionContext) {
        self.delegate.doNextStep(context)
    }
    
    func validate () -> Bool {
        preconditionFailure("The method must be overriden")
    }
    
    func context () -> ExecutionContext {
        preconditionFailure("The method must be overriden")
    }
}
