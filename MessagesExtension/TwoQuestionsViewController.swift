//
//  TwoQuestionsViewController.swift
//  bionic-app
//
//  Created by Vitaliy on 11/12/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

class TwoQuestionsViewController: BaseSchemaViewController {

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnLeft: RadioButton!
    @IBOutlet weak var lblLeft: UILabel!
    
    @IBOutlet weak var btnRight: RadioButton!
    @IBOutlet weak var lblRight: UILabel!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBAction func onClick() {
        super.next()
    }
        
    override func validate () -> Bool {
        
        return btnLeft.isSelected || btnRight.isSelected
    }
        
    override func context () -> Result {
        let code = btnLeft.isSelected ? self.schema.questions[0].code : self.schema.questions[1].code;
        
        return Result(userIdentifier: schema.userIdentifier, code: self.schema.code, selectionCode: code)
    }
        
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblTitle.text = self.schema.titles[0].text
        lblTitle.sizeToFit()
        
        btnLeft.alternateButton = [btnRight]
        btnLeft.showImage(imageUrl: self.schema.questions[0].imageUrl!)
        lblLeft.text = self.schema.questions[0].text
        lblLeft.sizeToFit()
        
        btnRight.alternateButton = [btnLeft]
        btnRight.showImage(imageUrl: self.schema.questions[1].imageUrl!)
        lblRight.text = self.schema.questions[1].text
        lblRight.sizeToFit()
        
        btnNext.layer.cornerRadius = 8
        btnNext.layer.masksToBounds = true
        btnNext.setTitle(self.schema.buttons[0].text, for: UIControlState.normal)
    }
}
