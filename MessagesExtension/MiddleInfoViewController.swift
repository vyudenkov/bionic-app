//
//  MiddleInfoViewController.swift
//  bionic-app
//
//  Created by Vitaliy on 11/11/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

class MiddleInfoViewController: BaseQuestionViewController {

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnMiddle: UIButton!
    @IBAction func onClick() {
        delegate.doNextStep(Result(userIdentifier: self.schema.userIdentifier, code: self.schema.code))
    }
    
    @IBOutlet weak var lblImageText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = self.schema.titles[0].text
        lblTitle.sizeToFit()
        
        if let url = URL(string: self.schema.buttons[0].imageUrl!) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.btnMiddle.setImage(UIImage(data: data!), for: UIControlState.normal)
                    let sizeSide = min(self.btnMiddle.frame.width, self.btnMiddle.frame.height)
                    self.btnMiddle.frame = CGRect.init(x: 0, y: 0, width: sizeSide, height: sizeSide)
                    self.btnMiddle.layer.cornerRadius = sizeSide/2.0
                    self.btnMiddle.layer.borderColor = UIColor.red.cgColor
                    self.btnMiddle.layer.masksToBounds = true
                    self.btnMiddle.clipsToBounds = true
                }
            }
        }
         
        lblImageText.text = self.schema.buttons[0].text
        lblImageText.sizeToFit()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
