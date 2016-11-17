//
//  StaticImageViewController.swift
//  bionic-app
//
//  Created by Vitaliy on 11/2/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

class StaticImageViewController: BaseQuestionViewController {

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lblImageText: UILabel!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBAction func btnNextClick() {
        self.delegate.doNextStep(Result(userIdentifier: schema.userIdentifier, code: self.schema.code))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // prepare button
        btnNext.layer.cornerRadius = 8
        btnNext.layer.borderColor = UIColor.red.cgColor
        btnNext.layer.masksToBounds = true
        btnNext.setTitle(self.schema.buttons[0].text, for: UIControlState.normal)
        
        // prepare header text
        lblTitle.text = self.schema.titles[0].text
        
        if self.schema.titles.count > 1 {
            let question = self.schema.titles[1]
            lblImageText.text = question.text
            lblImageText.sizeToFit()
            image.showImage(imageUrl: question.imageUrl!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
