//
//  StaticImageYesNoViewController.swift
//  bionic-app
//
//  Created by Vitaliy on 11/8/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

class StaticImageYesNoViewController: BaseQuestionViewController {

    @IBOutlet weak var btnNo: UIButton!
    @IBAction func btnNoClick() {
        self.delegate.doNextStep(Result(userIdentifier: schema.userIdentifier, code: self.schema.code, selectionCode: self.schema.buttons[0].code))
    }
    
    @IBOutlet weak var btnYes: UIButton!
    @IBAction func btnYesClick() {
        self.delegate.doNextStep(Result(userIdentifier: schema.userIdentifier, code: self.schema.code, selectionCode: self.schema.buttons[1].code))
    }
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblImageText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // prepare header text
        lblTitle.text = self.schema.titles[0].text
        lblTitle.sizeToFit()
        
        imageView.showImage(imageUrl: self.schema.titles[1].imageUrl!)
        lblImageText.text = self.schema.titles[1].text
        
        // prepare buttons
        btnNo.layer.cornerRadius = 8
        btnNo.layer.masksToBounds = true
        btnNo.setTitle(self.schema.buttons[0].text, for: UIControlState.normal)
        
        btnYes.layer.cornerRadius = 8
        btnYes.layer.masksToBounds = true
        btnYes.setTitle(self.schema.buttons[1].text, for: UIControlState.normal)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}
