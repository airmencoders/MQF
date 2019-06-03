//
//  QuestionAnswerCollectionViewCell.swift
//  MQF
//
//  Created by Christian Brechbuhl on 5/27/19.
//  Copyright © 2019 Umbo LLC. All rights reserved.
//

import UIKit

class QuestionAnswerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var answerLabel: UILabel!
    @IBOutlet var answerIDlabel: UILabel!
    
    func setColor(answerColor:AnswerColor){
        let color = colorForAnswerColor(answerColor: answerColor)
        self.answerLabel.textColor = color
    }
    
    enum AnswerColor {
        case Correct
        case Incorrect
        case Selected
        case Normal
        
    }
    
    func colorForAnswerColor(answerColor:AnswerColor)->UIColor{
        switch answerColor {
        case .Correct:
            return UIColor.green
        case .Incorrect:
            return UIColor.red
        case .Selected:
            return UIColor.blue
        default:
            return UIColor.black
        }
    }
}
