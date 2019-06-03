//
//  FirstViewController.swift
//  MQF
//
//  Created by Christian Brechbuhl on 5/25/19.
//  Copyright © 2019 Umbo LLC. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadQuiz()
    }
    
    func loadQuiz() {
        guard let path = Bundle.main.path(forResource: "new-quiz", ofType: "json") else {
            return
        }
        
        QKSession.default.limit = 10
        
        if let quiz = QKQuiz(loadFromJSONFile: path) {
            QKSession.default.load(quiz: quiz)
            self.startQuiz(self)
        }
    }
    
    @IBAction func startQuiz(_ sender: Any) {
        do {
            try QKSession.default.start()
        } catch {
            fatalError("Quiz started without quiz set on the session")
        }
        
        if let question = QKSession.default.nextQuestion() {
            // SHOW THE QUESTION VIEW HERE
            print(question.question)
        }
    }


}

