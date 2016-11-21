//
//  QuestionCollectionViewController.swift
//  bionic-app
//
//  Created by Vitaliy on 11/1/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

class QuestionCollectionViewCell : UICollectionViewCell {

    @IBOutlet weak var btnTitle: UILabel!
    
    @IBOutlet weak var imageButton: RoundRadioButton!
    
    var question: Element? = nil {
        didSet {
            self.btnTitle.text = question!.text
            self.btnTitle.sizeToFit()
            self.imageButton.showImage(imageUrl: question!.imageUrl!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
}

class TwoQuestionViewController: BaseQuestionViewController {

    var buttons: [RoundRadioButton] = []
    
    @IBOutlet weak var button1: RoundRadioButton!
    @IBOutlet weak var button1Label: UILabel!
    
    @IBOutlet weak var button2: RoundRadioButton!
    @IBOutlet weak var button2Label: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBAction func btnNextClick() {
        super.next()
    }
    
    override func validate () -> Bool {
        return buttons.contains(where: { ( cell: RoundRadioButton ) -> Bool in return cell.isSelected })
    }
    
    override func context () -> ExecutionContext {
        let code = button1.isSelected ? self.schema.questions[0].code : self.schema.questions[1].code
        return Result(userIdentifier: schema.userIdentifier, code: self.schema.code, selectionCode: code)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // prepare button
        btnNext.layer.cornerRadius = 8
        btnNext.layer.borderColor = UIColor.red.cgColor
        btnNext.layer.masksToBounds = true
        btnNext.setTitle(schema.buttons[0].text, for: UIControlState.normal)
        
        // prepare header text
        lblTitle.text = self.schema.titles[0].text
        
        buttons = [button1, button2]
        button1.showImage(imageUrl: schema.questions[0].imageUrl!)
        button1.alternateButton = buttons
        button1Label.text = schema.questions[0].text
        button1Label.sizeToFit()
        
        button2.showImage(imageUrl: schema.questions[1].imageUrl!)
        button2.alternateButton = buttons
        button2Label.text = schema.questions[1].text
        button2Label.sizeToFit()
    }
}
