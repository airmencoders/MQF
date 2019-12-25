//
//  QuestionTableViewCell.swift
//  MQF
//
//  Created by Christian Brechbuhl on 6/2/19.


import UIKit

/// Cell for each question in `ResultTableViewController`
class QuestionTableViewCell: UITableViewCell {

    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answersStackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// Set up the cell for the given question
    /// Adds the question and each answer and collors them
    ///
    /// - parameters:
    ///     -  question:  `QKQuestion` the relevant question
    ///     - session: `QKSession` the current quiz sesson
    func setUp(question:QKQuestion, session:QKSession){
        self.questionLabel.text = question.question
        let responseProvided = session.response(for: question)
        var correct = true
        //If wrong response, make the question red
        if(responseProvided != question.correctResponse){
            self.questionLabel.textColor = UIColor.red
            correct = false
        }else{
            self.questionLabel.textColor = UIColor.darkText
        }
        
        //Remove any existing answers, required because table view reuses cells
        for v in self.answersStackView.arrangedSubviews{
            self.answersStackView.removeArrangedSubview(v)
            v.removeFromSuperview()
        }
        
        //Add each reponse and color it
        var c = 0
        for response in question.responses{
            let label = UILabel()
            label.text = "\(question.answerID(index: c)): \(response)"
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            if(response == question.correctResponse){
                label.textColor = UIColor.green
            }
            if(!correct && response == responseProvided){
              label.textColor = UIColor.red
            }
            self.answersStackView.addArrangedSubview(label)
            c += 1
        }
        let label = UILabel()
        label.text = "Ref: \(question.reference ?? "")"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = UIColor.darkGray
        self.answersStackView.addArrangedSubview(label)
        self.layoutSubviews()
    }
 
}
