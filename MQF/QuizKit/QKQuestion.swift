//
//  QKQuestion.swift
//  QuizKit
//
//  Created by Stephen Radford on 12/03/2018.
//  Copyright © 2018 Cocoon Development Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Represents a question within the quiz
public struct QKQuestion: Hashable {
    
    /// The question
    public let question: String

    /// The category that the question relates to
    public let category: String?
    
    /// Responses for the question
    public let responses: [String]
    
    /// Reference for the question
    public let reference: String?

    /// Optionally labels can be set for a question that can be used in addition to images or to replace responses visible to the player
    public let labels: [String]
    
    /// Shuffled responses
    public var shuffledResponses: [String] {
        return responses.shuffled()
    }
    
    /// The correct response for the question
    public var correctResponse: String {
        if(responses.count > correctResponseIndex && correctResponseIndex > 0){
        return responses[correctResponseIndex]
        }
            return ""
        
    }
    
    /// The index of the correct response
    private let correctResponseIndex: Int
    
    /// An image relating to the question
    public let imageUrl: String?
    
    /// The type of question
    public let type: QKQuestionType
    
    internal init(json: [String:JSON]) {
        question = json["question"]?.string ?? ""
        category = json["category"]?.string ?? ""
        reference = json["ref"]?.string ?? ""
        responses = json["responses"]?.arrayObject as? [String] ?? []
        labels = json["labels"]?.arrayObject as? [String] ?? []
        correctResponseIndex = json["correct_response"]?.int ?? 0
        imageUrl = json["image_url"]?.string
        
        if let type = json["type"]?.string {
            switch type {
            case "single_answer":
                self.type = .singleAnswer
                break
            case "multiple_choice":
                self.type = .multipleChoice
                break
            case "image_choice":
                self.type = .imageChoice
                break
            default:
                self.type = .singleAnswer
                break
            }
        } else {
            self.type = .singleAnswer
        }
        
    }
    
    
    // MARK: - Hashable
    
    public var hashValue: Int {
        return question.hashValue
    }
    
    public static func ==(lhs: QKQuestion, rhs: QKQuestion) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    
    public func answerID(index:Int)->String{
        switch index {
        case 0:
            return "A"
        case 1:
            return "B"
        case 2:
            return "C"
        case 3:
            return "D"
        case 4:
            return "E"
        case 5:
            return "F"
        case 6:
            return "G"
            
        default:
            return "?"
        }
        
    }
}
