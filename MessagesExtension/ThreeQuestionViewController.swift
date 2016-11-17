//
//  ThreeQuestionViewController.swift
//  bionic-app
//
//  Created by Vitaliy on 11/2/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

class ThreeQuestionViewController: BaseQuestionViewController {

    var buttons: [RoundRadioButton] = []
    
    @IBOutlet weak var button1: RoundRadioButton!
    @IBOutlet weak var button1Label: UILabel!

    @IBOutlet weak var button2: RoundRadioButton!
    @IBOutlet weak var button2Label: UILabel!

    @IBOutlet weak var button3: RoundRadioButton!
    @IBOutlet weak var button3Label: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBAction func btnNextClick() {
        super.next()
    }
    
    override func validate () -> Bool {
        return buttons.contains(where: { ( cell: RoundRadioButton ) -> Bool in return cell.isSelected })
    }
    
    override func context () -> ExecutionContext {
        let code = button1.isSelected ? self.schema.questions[0].code : (
            button2.isSelected ? self.schema.questions[1].code : self.schema.questions[2].code
        )
        return Result(userIdentifier: schema.userIdentifier, code: self.schema.code, selectionCode: code)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // prepare header text
        lblTitle.text = self.schema.titles[0].text
        // prepare button
        btnNext.layer.cornerRadius = 8
        btnNext.layer.borderColor = UIColor.red.cgColor
        btnNext.layer.masksToBounds = true
        btnNext.setTitle(schema.buttons[0].text, for: UIControlState.normal)

        buttons = [button1, button2, button3]
        button1.showImage(imageUrl: schema.questions[0].imageUrl!)
        button1.alternateButton = buttons
        button1Label.text = schema.questions[0].text
        button1Label.sizeToFit()
       
        button2.showImage(imageUrl: schema.questions[1].imageUrl!)
        button2.alternateButton = buttons
        button2Label.text = schema.questions[1].text
        button2Label.sizeToFit()
        
        button3.showImage(imageUrl: schema.questions[2].imageUrl!)
        button3.alternateButton = buttons
        button3Label.text = schema.questions[2].text
        button3Label.sizeToFit()

    }
}
