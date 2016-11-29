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
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBAction func onClose() {
        deleteDelegate?.deleteHistory(item: historyItem!)
    }
    
    func itemTought(_ sender: UITapGestureRecognizer) {
        delegate?.showHistory(userIdentifier: userIdentifier, item: historyItem)
    }
    
    var delegate : ShowHistoryDelegate?
    var deleteDelegate : DeleteHistoryDelegate?
    
    var userIdentifier : UUID!
    
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
    
    var fullScreen: Bool? = nil {
        didSet {
            btnDelete.isHidden = fullScreen!
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

class MainPageViewController: BaseViewController, ButtonClickDelegate, DeleteHistoryDelegate, UITableViewDelegate, UITableViewDataSource {
    
    internal func deleteHistory(item: HistoryItem?) {
        self.showYesNoQuestions(message: "Delete... REALY???", action: {() in
            self.delete(gameId: (item?.gameIdentifier)!)
        });
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
    
    var assessment : Bool! = false
    
    var fullScreen : Bool! = false
    
    var buttonTitle : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + self.historyItems.count + (self.assessment == true ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Button Cell", for: indexPath) as! ButtonTableViewCell
            cell.delegate = self
            cell.code = "1"
            cell.buttonTitle = self.buttonTitle
            return cell
        } else if indexPath.row == self.historyItems.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Button Cell", for: indexPath) as! ButtonTableViewCell
            cell.delegate = self
            cell.code = "2"
            cell.buttonTitle = "Back To Assessment"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "History Cell", for: indexPath) as! HistoryItemTableViewCell
            cell.delegate = self.delegate
            cell.deleteDelegate = self
            cell.fullScreen = self.fullScreen
            cell.historyItem = self.historyItems[index - 1]
            cell.userIdentifier = self.userIdentifier
            let gesture = UITapGestureRecognizer(target: cell, action: #selector(HistoryItemTableViewCell.itemTought(_:)))
            cell.addGestureRecognizer(gesture)
            return cell
        }
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("delete")
            let i = index.row
            self.deleteHistory(item: self.historyItems[i - 1])
        }
        delete.backgroundColor = UIColor.orange
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            print("edit")
            let i = index.row
            self.delegate.showHistory(userIdentifier: self.userIdentifier, item: self.historyItems[i - 1])
        }
        return [edit, delete]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    private func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle) {
        print("Do something")
    }
    
    func process(json: Dictionary<String, Any>) {
        self.historyItems = []
        if let hasAssessment = json["assessment"] as? Bool {
            self.assessment = hasAssessment
        }
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
