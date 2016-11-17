//
//  QuestionCollectionViewController.swift
//  bionic-app
//
//  Created by Vitaliy on 11/1/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import UIKit

class QuestionCollectionViewCell : UICollectionViewCell {

    @IBOutlet weak var btnTitle: UILabel!
    
    @IBOutlet weak var imageButton: RoundRadioButton!
    
    var question: Element? = nil {
        didSet {
            self.btnTitle.text = question!.text
            self.btnTitle.sizeToFit()
            self.imageButton.showImage(imageUrl: question!.imageUrl!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
}

class QuestionCollectionViewController: BaseQuestionViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    private var reusableCells: [QuestionCollectionViewCell] = []
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBAction func btnNextClick() {
        super.next()
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func validate () -> Bool {
        return reusableCells.contains(where: { ( cell: QuestionCollectionViewCell ) -> Bool in return cell.imageButton.isSelected })
    }
    
    override func context () -> ExecutionContext {
        if let cell = reusableCells.first(where: { ( cell: QuestionCollectionViewCell ) -> Bool in return cell.imageButton.isSelected }) {
            
            return Result(userIdentifier: schema.userIdentifier, code: self.schema.code, selectionCode: (cell.question?.code)!)
        }
        preconditionFailure("The method must be overriden")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // prepare button
        btnNext.layer.cornerRadius = 8
        btnNext.layer.borderColor = UIColor.red.cgColor
        btnNext.layer.masksToBounds = true
        btnNext.setTitle(schema.buttons[0].text, for: UIControlState.normal)
        
        // prepare header text
        lblTitle.text = self.schema.titles[0].text

        collectionView.delegate = self
        collectionView.dataSource = self
        
        // imitialize radiobutton feature (single image selection)
        var buttons: [RadioButton] = []
        for i in 0..<schema.questions.count {
            if let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: IndexPath(row: i, section: 0)) as? QuestionCollectionViewCell {
                cell.question = schema.questions[i]
                let button = cell.imageButton
                button?.showImage(imageUrl: schema.questions[i].imageUrl!)
                buttons.append(button!)
                reusableCells.append(cell)
            }
        }
        
        for button in buttons {
            button.alternateButton = buttons
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.schema.questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return reusableCells[indexPath.row]
    }
}
