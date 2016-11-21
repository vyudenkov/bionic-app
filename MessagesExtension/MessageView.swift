//
//  MessageView.swift
//  bionic-app
//
//  Created by Vitaliy on 11/18/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

class MessageViewCell : UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    var imageUrl: String? = nil {
        didSet {
            self.productImage.showImage(imageUrl: imageUrl!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
}

class MessageView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var images: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.backgroundColor = UIColor.clear
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Image Cell", for: indexPath) as! HistoryItemCollectionViewCell
        cell.imageUrl = self.images[indexPath.row]
        return cell;
    }

}
