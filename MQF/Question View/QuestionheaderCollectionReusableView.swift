//
//  QuestionheaderCollectionReusableView.swift
//  MQF
//
//  Created by Christian Brechbuhl on 5/27/19.
//  Copyright © 2019 Umbo LLC. All rights reserved.
//

import UIKit
import UICircularProgressRing
class QuestionheaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet var questionLabel: UILabel!

    @IBOutlet var scoreStackView: UIStackView!
    @IBOutlet var progressRing: UICircularProgressRing!
    
    @IBOutlet var scoreRing: UICircularProgressRing!
    
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
    
    func updateProgress(session:QKSession, question:QKQuestion){
        self.progressRing.style = .ontop
        self.progressRing.maxValue = CGFloat(session.questionCount)
        let vf = UICircularProgressRingFormatter.init(valueIndicator: " of \(session.questionCount)", rightToLeft: false, showFloatingPoint: false, decimalPlaces: 0)
        self.progressRing.valueFormatter = vf
        
        self.progressRing.value = CGFloat(session.questionIndex(for: question))
        
    }
    
    func setRingSizes(size:Int){
        self.progressRing.frame.size = CGSize(width: size, height: size)
        self.scoreRing.frame.size = CGSize(width: size, height: size)
    }
}
