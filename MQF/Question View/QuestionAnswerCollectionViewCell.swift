//
//  QuestionAnswerCollectionViewCell.swift
//  MQF
//
//  Created by Christian Brechbuhl on 5/27/19.


import UIKit
/// The quiz  answer cell
class QuestionAnswerCollectionViewCell: UICollectionViewCell {
    /// The verbage of each answer
    @IBOutlet var answerLabel: UILabel!
    /// The label of each answer (A, B. C, D, etc)
    @IBOutlet var answerIDlabel: UILabel!
    
    /// Sets the color of the based on the action and if its correct or not
    /// - Parameters:
    ///     - answerColor: `AnswerColor` type of color to  be appiied
    func setColor(answerColor:AnswerColor){
        let color = colorForAnswerColor(answerColor: answerColor)
        self.answerLabel.textColor = color
    }
    /// Enum for answer colors, based on type of action, converts to a `UIColor`
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
