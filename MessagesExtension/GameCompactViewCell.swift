//
//  GameCompactViewCell.swift
//  bionic-apps
//
//  Created by Vitaliy on 10/19/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

class GameCompactViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.autoresizingMask = [.flexibleTopMargin ]
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
    }
}
