//
//  CustomViewController.swift
//  bionic-apps
//
//  Created by Vitaliy on 10/25/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

class ImageButtonTableViewCell : UITableViewCell {
    
    @IBOutlet weak var imageButton: RadioButton!
    
    var code : String?
    
    var imageUrl: String? = nil {
        didSet {
            self.imageButton.showImage(imageUrl: imageUrl!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageButton.contentMode = .scaleAspectFit
        imageButton.layer.cornerRadius = 8
        imageButton.layer.masksToBounds = true

        self.backgroundColor = UIColor.clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
    }
}

class TextTableViewCell : UITableViewCell {
    
    @IBOutlet weak var imageText: UILabel!
    
    var labelText: String? = nil {
        didSet {
            self.imageText.text = labelText
            self.imageText.sizeToFit()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
    }
}

class QuestionListViewController: BaseQuestionViewController, UITableViewDelegate, UITableViewDataSource {

    private var reusableCells: [ImageButtonTableViewCell] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet weak var btnNext: UIButton!
    @IBAction func btnNextClick() {

        super.next()
    }
    
    override func validate () -> Bool {
        return reusableCells.contains(where: { ( cell: ImageButtonTableViewCell ) -> Bool in return cell.imageButton.isSelected })
    }
    
    override func context () -> ExecutionContext {
        if let cell = reusableCells.first(where: { ( cell: ImageButtonTableViewCell ) -> Bool in return cell.imageButton.isSelected }) {
        
            return Result(userIdentifier: schema.userIdentifier, code: self.schema.code, selectionCode: cell.code!)
        }
        
        preconditionFailure("The method must be overriden")
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
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // initialize radiobutton feature (single image selection)
        var buttons: [RadioButton] = []
        for i in 0..<schema.questions.count {
            if let cell = tableView?.dequeueReusableCell(withIdentifier: "Image Button Cell", for: IndexPath(row: 2 * i, section: 0)) as? ImageButtonTableViewCell {
                cell.code = schema.questions[i].code
                let button = cell.imageButton
                button?.showImage(imageUrl: schema.questions[i].imageUrl!)
                buttons.append(button!)
                reusableCells.append(cell)
            }
        }
        
        for button in buttons {
            button.alternateButton = buttons
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 * self.schema.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row / 2
        let question = self.schema.questions[index]
        
        var cell : UITableViewCell
        if indexPath.row % 2 > 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "Text Cell", for: indexPath)
            (cell as! TextTableViewCell).labelText = question.text
        }
        else {
            cell = reusableCells[index]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
