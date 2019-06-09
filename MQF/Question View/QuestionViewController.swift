//
//  QuestionViewController.swift
//  MQF
//
//  Created by Christian Brechbuhl on 6/8/19.
//  Copyright © 2019 Umbo LLC. All rights reserved.
//

import UIKit
import UICircularProgressRing
class QuestionViewController: UIViewController {
    var activeQuestion:QKQuestion?
    var quizSession:QKSession = QKSession.default
    var mode:QuizMode = .Study
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var answersStackView: UIStackView!
    @IBOutlet var scoreStackView: UIStackView!
    @IBOutlet var progressRing: UICircularProgressRing!
    
    @IBOutlet var scoreRing: UICircularProgressRing!
    override func viewDidLoad() {
        super.viewDidLoad()
        let widthConstraint = NSLayoutConstraint(item: self.questionLabel, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.width)
        self.view.addConstraint(widthConstraint);
        // Do any additional setup after loading the view.
        self.startQuiz()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateView()
    }
    
    
    private func updateView(){
        
        self.addAnswerToStackView(text: "Test String")
        
        if(self.mode == .Test){
            self.scoreRing.alpha = 0.5
            self.scoreStackView.isHidden = true
            self.scoreRing.style = .ontop
        }else{
            self.updateScore(session: quizSession)
        }
        if((activeQuestion) != nil){
            self.questionLabel.text = activeQuestion?.question
            self.updateProgress(session: quizSession, question: activeQuestion!)
        }else{
            self.questionLabel.text = "Please select a MQF"
        }
        
        
        //Set Up Answers
        for v in self.answersStackView.arrangedSubviews{
            self.answersStackView.removeArrangedSubview(v)
            v.removeFromSuperview()
        }
        
        for answer in self.activeQuestion?.responses ?? [String](){
            self.addAnswerToStackView(text: answer)
        }
    }

    func addAnswerToStackView(text:String){
        let view = UIView()
        view.layer.cornerRadius = 20.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.clear.cgColor
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = true;
        let label = UILabel.init()
        label.text = text
        label.textColor = .lightText
        self.answersStackView.addArrangedSubview(view)
    }
    
    
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func startQuiz() {
        do {
            try quizSession.start()
        } catch {
            fatalError("Quiz started without quiz set on the session")
        }
        
        if let question = quizSession.nextQuestion() {
            // SHOW THE QUESTION VIEW HERE
            self.activeQuestion = question
            
        }
    }
    
    func nextQuestion(){
        print("next")
        
        if let question = quizSession.nextQuestion(after: self.activeQuestion) {
            // SHOW THE QUESTION VIEW HERE
            self.activeQuestion = question
            self.updateView()
        }else{
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nc = storyBoard.instantiateViewController(withIdentifier: "ResultsNC") as! UINavigationController
            let vc = nc.topViewController as! ResultsTableViewController
            vc.session = quizSession
            
            let parent = self.presentingViewController!
            
            parent.dismiss(animated: true, completion: {
                
                parent.present(nc, animated: true, completion: nil)
            })
            
            
        }
    }
}
enum QuizMode {
    case Study
    case Test
}
