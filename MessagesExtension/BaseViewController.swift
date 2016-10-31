//
//  BaseViewController.swift
//  bionic-apps
//
//  Created by Vitaliy on 10/31/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showWarning()
    {
        if self.view.viewWithTag(100) == nil {
            let modalView = UIView(frame: self.view.frame.offsetBy(dx: 0, dy: -85))
            modalView.tag = 100
            modalView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            
            let warningView = UIView(frame: CGRect(x: 50, y: 50, width: self.view.frame.width - 100, height: 150))
            warningView.backgroundColor = UIColor.white
            warningView.isUserInteractionEnabled = true
            warningView.clipsToBounds = true
            warningView.layer.cornerRadius = 8
            warningView.layer.masksToBounds = true
            warningView.center.x = modalView.center.x
            
            let image = UIImageView(frame: CGRect(x: 0, y: 15, width: 85, height: 85))
            image.image = #imageLiteral(resourceName: "WarningIcon")
            image.center.x = warningView.center.x - 50
            
            let label = UILabel(frame: CGRect(x: 0, y: 110, width: 85, height: 85))
            label.text = "Please make a choice"
            label.font = label.font.withSize(23)
            label.sizeToFit()
            label.center.x = warningView.center.x - 50
            
            warningView.addSubview(image)
            warningView.addSubview(label)
            
            modalView.addSubview(warningView)
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.warningTought(_:)))
            modalView.addGestureRecognizer(gesture)
            self.view.addSubview(modalView)
        }
    }
    
    func warningTought(_ sender: UITapGestureRecognizer) {
        if let warningView = self.view.viewWithTag(100) {
            warningView.removeFromSuperview()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
