//
//  MenuViewController.swift
//  MQF
//
//  Created by Christian Brechbuhl on 5/28/19.
//  Copyright © 2019 Umbo LLC. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet var squadronLeft: UIImageView!
    @IBOutlet var squadronRight: UIImageView!
    @IBOutlet var mdsOutlet: UILabel!
    @IBOutlet var crewPositionOutlet: UILabel!
    @IBOutlet var chooseOutlet: UIButton!
    @IBOutlet var mqfsStackView: UIStackView!
    private var activeMQFs = [MQFData]()
    private var hiddenTapCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        if(!(MQFDefaults().object(forKey: MQFDefaults.squadronHidden) as? Bool ?? false)){
            self.squadronLeft.isHidden = true
            self.squadronRight.isHidden = true
        }
        chooseOutlet.alignImageAndTitleVertically()
        
        // Do any additional setup after loading the view.
        DataManager.shared.load()
        
        let gr = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.sixteenTaps(sender:)))
        self.mdsOutlet.addGestureRecognizer(gr)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for v in self.mqfsStackView.arrangedSubviews{
            self.mqfsStackView.removeArrangedSubview(v)
            v.removeFromSuperview()
        }
        self.mdsOutlet.text = MQFDefaults().string(forKey: MQFDefaults.mds) ?? "C-17"
        self.crewPositionOutlet.text = MQFDefaults().string(forKey: MQFDefaults.crewPosition) ?? "Pilot"
        
        let mode = MQFDefaults().object(forKey: MQFDefaults.activeMode) as? String ?? "MQF"
        let activePresetID = MQFDefaults().object(forKey: MQFDefaults.activePresetID) as? String ?? "c17-Pilot.json"
        self.activeMQFs = [MQFData]()
        if(mode == "MQF"){
            let mqf = DataManager.shared.getMQFData(for: activePresetID) ?? MQFData()
           self.activeMQFs.append(mqf)
           self.addLabelToStakcView(text: mqf.name)
        }else{
            let preset = DataManager.shared.getPreset(for: activePresetID) ?? MQFPreset()
            for mqf in preset.mqfs{
                self.addLabelToStakcView(text: mqf.name)
                self.activeMQFs.append(mqf)
            }
        }
        
        
    }
    
  
    @objc private func sixteenTaps(sender:UITapGestureRecognizer){
        self.hiddenTapCount += 1
        if(self.hiddenTapCount == 6){
            self.squadronLeft.isHidden = true
            self.squadronRight.isHidden = true
            MQFDefaults().set(false, forKey: MQFDefaults.squadronHidden)
            MQFDefaults().synchronize()
        }
        if(self.hiddenTapCount == 16){
            self.squadronLeft.isHidden = false
            self.squadronRight.isHidden = false
            MQFDefaults().set(true, forKey: MQFDefaults.squadronHidden)
            MQFDefaults().synchronize()
        }
    }
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Study" || segue.identifier == "Test"){
        let quizSession = QKSession.default
        var superQuiz = QKQuiz()
        let quizSize = MQFDefaults().object(forKey: MQFDefaults.quizSize) as? Int ?? 0
        var testTotalQuestions = 0
        for mqf in self.activeMQFs{
            testTotalQuestions += mqf.testNum
        }
        for mqf in self.activeMQFs{
            var limit = 0
            if(quizSize != 0 && testTotalQuestions != 0){
                let proportion = Double (mqf.testNum) / Double(testTotalQuestions)
                limit = Int(proportion * Double(quizSize))
            }
            let name = mqf.filename.replacingOccurrences(of: ".json", with: "")
            guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
                return
            }
            if let quiz = QKQuiz(loadFromJSONFile: path) {
                if(mqf == self.activeMQFs.last){
                    if(superQuiz.orderedQuestions.count + limit < quizSize){
                        limit = quizSize - superQuiz.orderedQuestions.count
                    }
                }
                superQuiz.appendQuiz(quiz: quiz, limit:limit)
            }
            
        }
        
            quizSession.limit = 10
            quizSession.load(quiz: superQuiz)
            if(segue.identifier == "Study"){
                let vc = segue.destination as! QuestionCollectionViewController
                vc.mode = .Study
                vc.quizSession = quizSession
            }else if(segue.identifier == "Test"){
                let vc = segue.destination as! QuestionCollectionViewController
                vc.mode = .Test
                vc.quizSession = quizSession
            }
                
        }
        
        
       
    }
 
   
    
    @IBAction func sendFeedback(_ sender: Any) {
        let alert = UIAlertController.init(title: "We'd love to hear from you!", message: "This app was built for aircrew by aircrew to make one small part of your life simpler and easier. Help us achieve that goal with your feedback. Please email it to christian.brechbuhl@us.af.mil. Thanks!", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Will Do!", style: .default, handler: nil)
        
        //now we are adding the default action to our alertcontroller
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    

    
    func addLabelToStakcView(text:String){
        let label = UILabel.init()
        label.text = text
        label.textColor = .lightText
        self.mqfsStackView.addArrangedSubview(label)
    }
}
