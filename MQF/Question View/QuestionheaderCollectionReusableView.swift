//
//  QuestionheaderCollectionReusableView.swift
//  MQF
//
//  Created by Christian Brechbuhl on 5/27/19.


import UIKit
import UICircularProgressRing

/// Header for question view
/// Shows both the current max possible score, number of questions answered, and the current question
class QuestionheaderCollectionReusableView: UICollectionReusableView {
    /// The verbage of the current question
    @IBOutlet var questionLabel: UILabel!
    /// Stack view that holds the score information and label
    @IBOutlet var scoreStackView: UIStackView!
    /// Ring that shows how what percentage of  questions have been answered
    @IBOutlet var progressRing: UICircularProgressRing!
    /// Ring that shows the max possible score if all remaining questions are answered correctly
    @IBOutlet var scoreRing: UICircularProgressRing!
    
    /// Updates the score ring
    /// - Parameters:
    ///     - session: `QKSession` current quiz session
    func updateScore(session:QKSession){
            let remaining = session.questionCount - session.responseCount
            let possibleCorrect = session.score + remaining
            let percent = Double(possibleCorrect) / Double(session.questionCount)
        if(percent > 0.0){
            self.scoreRing.value = CGFloat(percent*100)
        }else{
            self.scoreRing.value = CGFloat(0)
        }
            self.scoreRing.style = .ontop
    }
    
    /// Updates the progress ring base on how many questions have been reviewed
    /// - Parameters:
    ///     - sesson: `QKSession` current quiz session
    ///     - question: `QKQuestions` current question
    func updateProgress(session:QKSession, question:QKQuestion){
        self.progressRing.style = .ontop
        self.progressRing.maxValue = CGFloat(session.questionCount)
        
        let vf = UICircularProgressRingFormatter.init(valueIndicator: "/\(session.questionCount)", rightToLeft: false, showFloatingPoint: false, decimalPlaces: 0)
        self.progressRing.valueFormatter = vf
        
        self.progressRing.value = CGFloat(session.questionIndex(for: question))
        
    }
    
    /// sets the size of the rings
    /// - Parameters:
    ///     - size: `Int` the desired size (applied to height and width)
    func setRingSizes(size:Int){
        self.progressRing.frame.size = CGSize(width: size, height: size)
        self.scoreRing.frame.size = CGSize(width: size, height: size)
    }
}
