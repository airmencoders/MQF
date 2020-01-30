//
//  QKQuestion.swift
//  MQFTests
//
//  Created by Christian Brechbuhl on 1/29/20.
//  Copyright © 2020 Airmen Coders, US Air Force - See INTENT.md for license type information. All rights reserved.
//

import XCTest
@testable import MQF
@testable import SwiftyJSON

class QKQuestionTests: XCTestCase {

    // MARK: QKQuestion
    func testCreateQuestion(){
        let jsonString = "{\"question\":\"24. ircrew will start the APU approximately _____ minutes prior to engine start to accomplishSCEFC and FCC hydraulic preflight tests and, after landing, will delay APU start untilapproximately _____ minutes from block in.\",\"type\":\"multiple_choice\",\"correct_response\":2,\"ref\":\"AFI11-2C-17V3_CHARLESTONAFBSUP, 5.34.1.3 and 5.34.2.1\",\"responses\":[\"10, 4\",\"10, 5\",\"15, 4\",\"15, 5\"]}";
        let json = JSON(parseJSON: jsonString)
        let question = QKQuestion(json: json.dictionary ?? ["No luck":JSON()])
        let shuffled = question.shuffledResponses
        XCTAssertEqual(question.correctResponse, "15, 4", "Wrong correct answer")
        XCTAssertEqual(question.responses, ["10, 4","10, 5","15, 4","15, 5"], "Wrong responses")
        XCTAssertEqual(question.shuffledResponses.count, 4, "Wrong number of shuffled responses")
        XCTAssertEqual(question.question, "24. ircrew will start the APU approximately _____ minutes prior to engine start to accomplishSCEFC and FCC hydraulic preflight tests and, after landing, will delay APU start untilapproximately _____ minutes from block in.", "Wrong questions")
        XCTAssertEqual(question.reference, "AFI11-2C-17V3_CHARLESTONAFBSUP, 5.34.1.3 and 5.34.2.1", "Wrong reference")
        XCTAssertEqual(question.answerID(index: 0), "A")
        XCTAssertEqual(question.answerID(index: 1), "B")
        XCTAssertEqual(question.answerID(index: 2), "C")
        XCTAssertEqual(question.answerID(index: 3), "D")
        XCTAssertEqual(question.answerID(index: 4), "E")
        XCTAssertEqual(question.answerID(index: 5), "F")
        XCTAssertEqual(question.answerID(index: 6), "G")
        XCTAssertEqual(question.answerID(index: 1000), "?")
    }
    
    func testCreateEmptyQuestion(){
        let jsonString = "{}";
        let json = JSON(parseJSON: jsonString)
        let question = QKQuestion(json: json.dictionary ?? ["No luck":JSON()])
        
        XCTAssertEqual(question.correctResponse, "", "Wrong correct answer")
        XCTAssertEqual(question.responses, [], "Wrong responses")
        XCTAssertEqual(question.shuffledResponses.count, 0, "Wrong number of shuffled responses")
        XCTAssertEqual(question.question, "", "Wrong questions")
        XCTAssertEqual(question.reference, "", "Wrong reference")
    }
    func testCreateBadQuestion(){
        let jsonString = "{\"correct_response\":-2, \"type\":\"unknown\"}";
        let json = JSON(parseJSON: jsonString)
        let question = QKQuestion(json: json.dictionary ?? ["No luck":JSON()])
        
        XCTAssertEqual(question.correctResponse, "", "Wrong correct answer")
    }
    
    func testCreateSingleAnswerQuestion(){
        let jsonString = "{\"type\":\"single_answer\"}";
        let json = JSON(parseJSON: jsonString)
        let question = QKQuestion(json: json.dictionary ?? ["No luck":JSON()])
        
        XCTAssertEqual(question.type, QKQuestionType.singleAnswer, "Wrong question type")
    }
    
    func testCreateMultipleChoiceQuestion(){
        let jsonString = "{\"type\":\"multiple_choice\"}";
        let json = JSON(parseJSON: jsonString)
        let question = QKQuestion(json: json.dictionary ?? ["No luck":JSON()])
        
        XCTAssertEqual(question.type, QKQuestionType.multipleChoice, "Wrong question type")
    }
    
    func testCreateImageQuestion(){
          let jsonString = "{\"type\":\"image_choice\"}";
          let json = JSON(parseJSON: jsonString)
          let question = QKQuestion(json: json.dictionary ?? ["No luck":JSON()])
          
          XCTAssertEqual(question.type, QKQuestionType.imageChoice, "Wrong question type")
      }

}
