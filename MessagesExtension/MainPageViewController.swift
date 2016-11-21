//
//  MainPageViewController.swift
//  bionic-app
//
//  Created by Vitaliy on 11/15/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

protocol ShowHistoryDelegate {
    func showHistory(userIdentifier: UUID, item: HistoryItem?)
}

protocol DeleteHistoryDelegate {
    func deleteHistory(item: HistoryItem?)
    func clearAssessment()
}

protocol ButtonClickDelegate {
    func onClick(code: String?)
}

class ButtonTableViewCell : UITableViewCell {
    
    var delegate : ButtonClickDelegate?
    var code: String?
    var buttonTitle: String? = nil {
        didSet {
            startButton.setTitle(buttonTitle, for: UIControlState.normal)
        }
    }
    
    @IBOutlet weak var startButton: UIButton!
    @IBAction func onClick() {
        delegate?.onClick(code: code)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        startButton.layer.cornerRadius = 8

        startButton.layer.borderColor = UIColor.red.cgColor
        startButton.layer.masksToBounds = true
        
        self.backgroundColor = UIColor.clear
    }
}

class HistoryItemCollectionViewCell : UICollectionViewCell {
    
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

class HistoryItemTableViewCell : UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var imagesList: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPercent: UILabel!
    
    @IBAction func onClose() {
        deleteDelegate?.deleteHistory(item: historyItem!)
    }
    
    var delegate : ShowHistoryDelegate?
    var deleteDelegate : DeleteHistoryDelegate?
    
    var historyItem: HistoryItem? = nil {
        didSet {
            let percent = Int(historyItem?.percentDone ?? 0)
            lblPercent.text = "\(percent) %"
            lblPercent.sizeToFit()
            lblTitle.text = historyItem?.title
            lblTitle.sizeToFit()
            imagesList.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imagesList.delegate = self
        imagesList.dataSource = self
      
        self.backgroundColor = UIColor.clear
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.historyItem?.gameItems.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imagesList.dequeueReusableCell(withReuseIdentifier: "Image Cell", for: indexPath) as! HistoryItemCollectionViewCell
        cell.imageUrl = self.historyItem?.gameItems[indexPath.row]
        return cell;
    }
}

class MainPageViewController: UIViewController, ButtonClickDelegate, DeleteHistoryDelegate, UITableViewDelegate, UITableViewDataSource {
    
    internal func deleteHistory(item: HistoryItem?) {
        self.delete(gameId: (item?.gameIdentifier)!)
    }
    
    internal func onClick(code: String?) {
        if code == "1" {
            delegate?.showHistory(userIdentifier: self.userIdentifier, item: nil)
        } else {
            clearAssessment()
        }
    }

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: ShowHistoryDelegate!
    
    var historyItems : [HistoryItem] = []
 
    var userIdentifier : UUID!
    
    var buttonTitle : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + self.historyItems.count + (self.historyItems.count == 0 ? 0 : 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        
        var cell : UITableViewCell
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "Button Cell", for: indexPath)
            (cell as! ButtonTableViewCell).delegate = self
            (cell as! ButtonTableViewCell).code = "1"
            (cell as! ButtonTableViewCell).buttonTitle = self.buttonTitle
        } else if indexPath.row == self.historyItems.count + 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "Button Cell", for: indexPath)
            (cell as! ButtonTableViewCell).delegate = self
            (cell as! ButtonTableViewCell).code = "2"
            (cell as! ButtonTableViewCell).buttonTitle = "Back To Assessment"
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "History Cell", for: indexPath)
            (cell as! HistoryItemTableViewCell).delegate = self.delegate
            (cell as! HistoryItemTableViewCell).deleteDelegate = self
            (cell as! HistoryItemTableViewCell).historyItem = self.historyItems[index - 1]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row > 0 && indexPath.row <= self.historyItems.count {
            return CGFloat(90)
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func process(json: Dictionary<String, Any>) {
        self.historyItems = []
        if let items = json["items"] as? [Dictionary<String, Any>] {
           for item in items {
               let gameIdentifier = UUID(uuidString: (item["gameIdentifier"] as? String)!)!
               let title = item["title"] as! String
               let percentDone = item["percentDone"] as? Double ?? 0
            
               let history = HistoryItem(gameIdentifier: gameIdentifier, title: title, percentDone: percentDone)
               history.gameItems = (item["gameItems"] as? [String])!
               self.historyItems.append(history)
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func loadData() {
        
        let requestURL = URL(string: "\(Settings.serverPath)/history/\(self.userIdentifier.uuidString)")
        var request = URLRequest(url: requestURL!)
        request.httpMethod = "GET"
        
        print("=== Request History (GET): " + (requestURL?.absoluteString)!)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode == 200) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Any>
                        self.process(json: json)
                    } catch {
                        print("Error")
                    }
                } else {
                    print("!!!Incorrect status code: \(httpResponse.statusCode) - " + httpResponse.statusCode.description)
                }
            } else {
                print("!!!Response is null: " + error.debugDescription)
            }
        })
        task.resume()
    }
    
    func delete(gameId: UUID) {
        
        let requestURL = URL(string: "\(Settings.serverPath)/game/\(gameId.uuidString)")
        var request = URLRequest(url: requestURL!)
        request.httpMethod = "DELETE"
        
        print("=== DELETE History (DELETE): " + (requestURL?.absoluteString)!)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode == 200) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Any>
                        self.process(json: json)
                    } catch {
                        print("Error")
                    }
                } else {
                    print("!!!Incorrect status code: \(httpResponse.statusCode) - " + httpResponse.statusCode.description)
                }
            } else {
                print("!!!Response is null: " + error.debugDescription)
            }
        })
        task.resume()
    }
    
    func clearAssessment() {
        
        let requestURL = URL(string: "\(Settings.serverPath)/assessment/\(self.userIdentifier.uuidString)")
        var request = URLRequest(url: requestURL!)
        request.httpMethod = "DELETE"
        
        print("=== DELETE Assessment (DELETE): " + (requestURL?.absoluteString)!)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            self.delegate?.showHistory(userIdentifier: self.userIdentifier, item: nil)
        })
        task.resume()
    }
}
