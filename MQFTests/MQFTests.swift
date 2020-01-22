//
//  MQFTests.swift
//  MQFTests
//
//  Created by Christian Brechbuhl on 5/25/19.
//

import XCTest
@testable import MQF
@testable import SwiftyJSON

class MQFTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    /// Iterates through every preset to make sure it loads properly
    /// Then goes through each question to make sure it has at least 2 possible answers
    /// Submits the correct answer for each question to ensure user can get credit if they choose the correct one
    func testAllPresets(){
        DataManager.shared.load()
        let bases = DataManager.shared.availableBases
        XCTAssert(bases.count > 0, "No bases found")
        
        var presets = [MQFPreset]()
        for base in bases{
            for preset in base.presets{
                presets.append(preset)
            }
        }
        XCTAssert(presets.count > 0, "No presets found")
        
        for preset in presets{ // For each preset in data set
            var activeMQFs = [MQFData]()
            for mqf in preset.mqfs{
                activeMQFs.append(mqf)
            }
            
            let quizSession = QKSession.default
            var superQuiz = QKQuiz()
            var testTotalQuestions = 0
            for mqf in activeMQFs{
                testTotalQuestions += mqf.testNum
            }

            for mqf in activeMQFs{
                let name = mqf.filename.replacingOccurrences(of: ".json", with: "")
                guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
                    XCTFail("File not loaded")
                    return
                }
                if let quiz = QKQuiz(loadFromJSONFile: path) {
                    XCTAssert(quiz.orderedQuestions.count > 0, "No questions found for MQF \(name)")
                    superQuiz.appendQuiz(quiz: quiz, limit:0)
                }
            }
            quizSession.load(quiz: superQuiz)
            XCTAssert(superQuiz.orderedQuestions.count > 0, "No questions found")
       
            for question in superQuiz.orderedQuestions{
                XCTAssert(question.responses.count > 1, "Not enough responses found for \(question.question)")
                XCTAssert(question.responses.count < 8, "Too many possible answers found for \(question.question)") //If more than 7 ammend QKQuestion to include more labels and then update test
            }
     
            do {
                try quizSession.start()
            } catch {
                fatalError("Quiz started without quiz set on the session")
            }
            var activeQuestion:QKQuestion? = nil
            while let question = quizSession.nextQuestion(after: activeQuestion){
                XCTAssert(question.responses.count > 1, "No question responses found for \(question.question)")
                quizSession.submit(response: question.correctResponse, for: question)
                
                activeQuestion = question
            }
            
            XCTAssertEqual(quizSession.responseCount, superQuiz.orderedQuestions.count, "Different number of answers than questions")
            XCTAssertEqual(quizSession.score, superQuiz.orderedQuestions.count, "Score was not 100")
            quizSession.score
            

        }
        
       }
    
    /// Iterates through every MQF to make sure it loads properly
       /// Then goes through each question to make sure it has at least 2 possible answers
       /// Submits the correct answer for each question to ensure user can get credit if they choose the correct one
       func testAllMQFs(){
           DataManager.shared.load()
     
           
            let mqfs = DataManager.shared.availableMQFs
     
           XCTAssert(mqfs.count > 0, "No MQFs found")
           
           for mqf in mqfs{ // For each MQF in data set
            print("Testing \(mqf.mds) \(mqf.name)")
          
               let quizSession = QKSession.default
               var superQuiz = QKQuiz()
               var testTotalQuestions = 0
                   testTotalQuestions += mqf.testNum
            
                   let name = mqf.filename.replacingOccurrences(of: ".json", with: "")
                   guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
                    XCTFail("File not loaded")
                       return
                   }
                   if let quiz = QKQuiz(loadFromJSONFile: path) {
                       XCTAssert(quiz.orderedQuestions.count > 0, "No questions found for MQF \(name)")
                       superQuiz.appendQuiz(quiz: quiz, limit:0)
                   }
               
               quizSession.load(quiz: superQuiz)
               XCTAssert(superQuiz.orderedQuestions.count > 0, "No questions found")
          
               for question in superQuiz.orderedQuestions{
                   XCTAssert(question.responses.count > 1, "Not enough responses found for \(question.question)")
                   XCTAssert(question.responses.count < 8, "Too many possible answers found for \(question.question)") //If more than 7 ammend QKQuestion to include more labels and then update test
               }
        
               do {
                   try quizSession.start()
               } catch {
                   fatalError("Quiz started without quiz set on the session")
               }
               var activeQuestion:QKQuestion? = nil
               while let question = quizSession.nextQuestion(after: activeQuestion){
                   XCTAssert(question.responses.count > 1, "No question responses found for \(question.question)")
                   quizSession.submit(response: question.correctResponse, for: question)
                   
                   activeQuestion = question
               }
               
               XCTAssertEqual(quizSession.responseCount, superQuiz.orderedQuestions.count, "Different number of answers than questions")
               XCTAssertEqual(quizSession.score, superQuiz.orderedQuestions.count, "Score was not 100")
             
               

           }
           
          }
    
    /// Iterates through every MQF to make sure there are no bad charectors
       func testAllAnswersBadChars(){
           DataManager.shared.load()
     
           
            let mqfs = DataManager.shared.availableMQFs
     
           XCTAssert(mqfs.count > 0, "No MQFs found")
           
           for mqf in mqfs{ // For each MQF in data set
            print("Testing \(mqf.mds) \(mqf.name)")
          
               let quizSession = QKSession.default
               var superQuiz = QKQuiz()
               var testTotalQuestions = 0
                   testTotalQuestions += mqf.testNum
            
                   let name = mqf.filename.replacingOccurrences(of: ".json", with: "")
                   guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
                    XCTFail("File not loaded")
                       return
                   }
                   if let quiz = QKQuiz(loadFromJSONFile: path) {
                       XCTAssert(quiz.orderedQuestions.count > 0, "No questions found for MQF \(name)")
                       superQuiz.appendQuiz(quiz: quiz, limit:0)
                   }
               
               quizSession.load(quiz: superQuiz)
               XCTAssert(superQuiz.orderedQuestions.count > 0, "No questions found")
          
          
        
               do {
                   try quizSession.start()
               } catch {
                XCTFail("Quiz Failed to Start")
                   fatalError("Quiz started without quiz set on the session")
               }
               var activeQuestion:QKQuestion? = nil
               while let question = quizSession.nextQuestion(after: activeQuestion){
                   
                for answer in activeQuestion?.responses ?? [String](){
                    if answer.contains("\\/") {
                        XCTFail("Answer includes \\/ ")
                    }
                }
                   
                   activeQuestion = question
               }
             
               

           }
           
          }
    
    func testCreatePreset(){
           let jsonString = "{\"name\":\"437/315 AW Pilot Test\",\"id\":\"KCHS-Pilot-Airland\",\"positions\":[\"Pilot\"],\"mqfs\":[{\"testNum\":30,\"file\":\"c17-Pilot-1nov\"},{\"testNum\":5,\"file\":\"c17-KCHS-Pilot\"}],\"testTotal\":35}"
           let json = JSON(parseJSON: jsonString)
           let preset = MQFPreset.init(json: json)
           
        XCTAssertEqual(preset.name, "437/315 AW Pilot Test", "Wrong preset name")
        XCTAssertEqual(preset.crewPositions, ["Pilot"], "Wrong crew positions")
        XCTAssertEqual(preset.mqfs.count, 2, "Wrong number of MQFs")
       }

    
    func testCreateBase(){
        let jsonString = "{\"name\":\"Charleston AFB Test\",\"id\":\"1\",\"presets\":[{\"name\":\"437/315 AW Pilot\",\"id\":\"KCHS-Pilot-Airland\",\"positions\":[\"Pilot\"],\"mqfs\":[{\"testNum\":30,\"file\":\"c17-Pilot-1nov\"},{\"testNum\":5,\"file\":\"c17-KCHS-Pilot\"}],\"testTotal\":35}]}"
        let json = JSON(parseJSON: jsonString)
        let base = MQFBase.init(json: json)
        
        XCTAssertEqual(base.name, "Charleston AFB Test", "Wrong base name")
        XCTAssertEqual(base.presets.count, 1, "Wrong number of presets")
    }
    

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
