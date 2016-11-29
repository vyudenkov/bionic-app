//
//  BaseViewController.swift
//  bionic-apps
//
//  Created by Vitaliy on 10/31/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    func showWarning()
    {
        if self.view.viewWithTag(100) == nil {
            let modalView = UIView(frame: self.view.frame.offsetBy(dx: 0, dy: 86))
            modalView.tag = 100
            modalView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
            
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
    
    private var action : (() -> Void)? = nil
    
    func showYesNoQuestions(message: String, action: @escaping (() -> Void))
    {
        self.action = action
        
        if self.view.viewWithTag(101) == nil {
            let modalView = UIView(frame: self.view.frame.offsetBy(dx: 0, dy: 86))
            modalView.tag = 101
            modalView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
            
            let warningView = UIView(frame: CGRect(x: 50, y: 50, width: self.view.frame.width - 100, height: 250))
            warningView.backgroundColor = UIColor.white
            warningView.isUserInteractionEnabled = true
            warningView.clipsToBounds = true
            warningView.layer.cornerRadius = 8
            warningView.layer.masksToBounds = true
            warningView.center.x = modalView.center.x
            
            let image = UIImageView(frame: CGRect(x: 0, y: 15, width: 85, height: 85))
            image.image = #imageLiteral(resourceName: "WarningIcon")
            image.center.x = warningView.center.x - 50
            
            let label = UILabel(frame: CGRect(x: 0, y: 120, width: 85, height: 85))
            label.text = message
            label.font = label.font.withSize(23)
            label.sizeToFit()
            label.center.x = warningView.center.x - 50

            let yesButton = UIButton(frame: CGRect(x: 20, y: 180, width: 120, height: 40))
            yesButton.setTitle("YES", for: UIControlState.normal)
            //yesButton.titleLabel?.font = yesButton.titleLabel?.withSize(23)
            yesButton.backgroundColor = UIColor.green
            yesButton.layer.cornerRadius = 8
            yesButton.layer.masksToBounds = true
            yesButton.addTarget(self, action: #selector(yesTought), for: UIControlEvents.touchUpInside)
            
            let noButton = UIButton(frame: CGRect(x: warningView.frame.maxX - 190, y: 180, width: 120, height: 40))
            noButton.setTitle("NO", for: UIControlState.normal)
            //yesButton.titleLabel?.font = yesButton.titleLabel?.withSize(23)
            noButton.backgroundColor = UIColor.red
            noButton.addTarget(self, action: #selector(noTought), for: UIControlEvents.touchUpInside)
            noButton.layer.cornerRadius = 8
            noButton.layer.masksToBounds = true
            
            warningView.addSubview(image)
            warningView.addSubview(label)
            warningView.addSubview(yesButton)
            warningView.addSubview(noButton)
            
            modalView.addSubview(warningView)
            
            /*let gesture = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.warningTought(_:)))
            modalView.addGestureRecognizer(gesture)*/
            self.view.addSubview(modalView)
        }
    }

    func yesTought(_ sender: UIButton!) {
        if let warningView = self.view.viewWithTag(101) {
            warningView.removeFromSuperview()
        }
        self.action!()
        self.action = nil
        print("Yes tapped")
    }
    
    func noTought(_ sender: UIButton!) {
        if let warningView = self.view.viewWithTag(101) {
            warningView.removeFromSuperview()
        }
        self.action = nil
        print("No tapped")
    }
    
    func warningTought(_ sender: UITapGestureRecognizer) {
        if let warningView = self.view.viewWithTag(100) {
            warningView.removeFromSuperview()
        }
    }
}
