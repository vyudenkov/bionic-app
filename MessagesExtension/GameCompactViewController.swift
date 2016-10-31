//
//  GameCompactViewController.swift
//  bionic-apps
//
//  Created by Vitaliy on 10/19/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

protocol GameCompactSendMessageDelegate {
    func sendMessage(_ controller: GameCompactViewController, images: [GameImage])
}

class GameCompactViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var images: [GameImage] = []
    var delegate: GameCompactSendMessageDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClick(_ sender: AnyObject) {
        
        delegate?.sendMessage(self, images: images)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstCell", for: indexPath) as! GameCompactViewCell
        self.images[indexPath.row].showInView(imageView: cell.imageView)
        return cell
    }
}
