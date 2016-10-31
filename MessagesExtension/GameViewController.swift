//
//  GameTableViewController.swift
//  bionic-apps
//
//  Created by Vitaliy on 10/17/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

protocol GameViewControllerDelegate: class {
    func gameViewControllerDone(_ responses: [GameImageResponse])
}

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func okClick(_ sender: AnyObject) {
        
        var result: [GameImageResponse] = []
        
        for cell in tableView.visibleCells {
            let cc = cell as! GameTableViewCell
            result.append(cc.result())
        }
        self.delegate?.gameViewControllerDone(result)
    }

    weak var delegate: GameViewControllerDelegate?

    var request: FMKGameRequest!
/*    var images: [GameImage] = []
    
    func loadImages() -> [GameImage] {
        
        let im1 = GameImage(imageId: UUID.init(), imageUrl: "http://thelibertarianrepublic.com/wp-content/uploads/2013/06/Screen-Shot-2013-06-23-at-10.46.30-PM-1024x638.png")
        let im2 = GameImage(imageId: UUID.init(), imageUrl: "http://i725.photobucket.com/albums/ww260/Think_Mcfly_Think/NewImage-2.jpg?__SQUARESPACE_CACHEVERSION=1280461077925")
        return [im1, im2]
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //images = self.loadImages()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.request.images.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Game Cell", for: indexPath) as! GameTableViewCell

        cell.gameImage = self.request.images[indexPath.row]

        return cell
    }
}
