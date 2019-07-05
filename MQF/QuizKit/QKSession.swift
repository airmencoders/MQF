//
//  QKSession.swift
//  QuizKit
//
//  Created by Stephen Radford on 12/03/2018.
//  Copyright © 2018 Cocoon Development Ltd. All rights reserved.
//

import Foundation

public class QKSession {
    
    private init() { }
    
    /// The shared instance of the session
    public static let `default` = QKSession()
    
    /// The delegate for the session
    public weak var delegate: QKSessionDelegate?
    
    /// The quiz that the session is currently using
    private var quiz: QKQuiz?
    
    /// The chunk of questions being used in the session
    private var questionChunk = [QKQuestion]()
    
    /// The responses given by the user
    public private(set) var responses = [QKQuestion:Bool]()
    public private(set) var responsesDetail = [QKQuestion:String]()
    /// Limits the number of questions in the session
    public var limit: Int = 0
    
    /// The number of questions the user got correct
    public var score: Int {
        return responses.filter { $1 }.count
    }
    public var responseCount : Int {
        return responses.count
    }
    /// The number of questions in the set
    public var questionCount: Int {
        return questionChunk.count
    }

    /// The score the user achieved on the quiz
    public var formattedScore: String {
        let score = responses.filter { $1 }.count
        return "\(score) / \(responses.count)"
    }
    
    /// Loads a new quiz into the session
    ///
    /// - Parameter quiz: The quiz to load
    public func load(quiz: QKQuiz) {
        self.quiz = quiz
    }
    
    /// Starts the quiz and resets all responses from the previous quiz
    ///
    /// - Throws: Error if a quiz has not been loaded into the session
    public func start(random:Bool = false) throws {
        guard let quiz = quiz else {
            throw QKError.quizNotSetOnSession
        }
        
        if(random){
            let shuffled = quiz.shuffledQuestions
            questionChunk = ((limit > 0) && (shuffled.count > limit)) ? Array(shuffled[0..<limit]) : shuffled
        }else{
            questionChunk = quiz.orderedQuestions
        }
        responses = [QKQuestion:Bool]()
        
        delegate?.quizDidStart()
    }
    
    /// Load the next question in the quiz session
    ///
    /// - Parameter question: The current question
    /// - Returns: Index of the current question.
    public func questionIndex(for question: QKQuestion? = nil) -> Int {
        guard let question = question, let index = questionChunk.firstIndex(of: question) else {
            return -1
        }
        return index
    }
    
    /// Load the next question in the quiz session
    ///
    /// - Parameter question: The current question
    /// - Returns: The next question or nil if it's the last question in the list.
    public func nextQuestion(after question: QKQuestion? = nil) -> QKQuestion? {
        guard let question = question, let index = questionChunk.firstIndex(of: question) else {
            if(questionChunk.count == 0){
                return nil
            }
            return questionChunk[0]
        }
        
        if questionChunk.last == question {
            delegate?.quizDidEnd()
            return nil
        }
        
        return questionChunk[index + 1]
    }
    
    
    public func restartSessionNextQuestion() -> QKQuestion? {
        self.responses = [QKQuestion:Bool]()
        self.responsesDetail = [QKQuestion:String]()
        guard let question = questionChunk.first else {
            return nil
            
        }
   return question
    }
    
    /// Submit a response to a question
    ///
    /// - Parameters:
    ///   - response: The response to submit
    ///   - question: The question the response relates to
    @discardableResult public func submit(response: String, for question: QKQuestion) -> Bool {
        let isCorrect = question.correctResponse == response
        responses[question] = isCorrect
        responsesDetail[question] = response
        return isCorrect
    }
    
    /// Returns the progress value for the current question. This is great for use in a `UIProgressView`
    ///
    /// - Parameter question: The question to detect the progress for
    /// - Returns: The progress as a Float
    public func progress(for question: QKQuestion) -> Float {
        guard let index = questionChunk.firstIndex(of: question) else {
            return 0
        }
        
        let current = Float(Int(index) + 1)
        return current / Float(questionChunk.count)
    }
    
    /// Returns the progress value for the current question. This is great for use in a `UIProgressView`
    ///
    /// - Parameter index: The index of the current question
    /// - Returns: The progress as a float
    public func progress(for index: Int) -> Float {
        let current = Float(Int(index) + 1)
        return current / Float(questionChunk.count)
    }
    
    
    /// Returns the question at the provided index
    ///
    /// - Parameter index: The index of the desired question
    /// - Returns: The QKQuestion for selected index
    public func question(for index: Int) -> QKQuestion? {
        if(questionChunk.count > index){
            return questionChunk[index]
        }else{
            return nil
        }
    }
    
    /// Returns the response for given question or nil if not yet answered
    ///
    /// - Parameter question: The question
    /// - Returns: Provided answer or nil
    public func response(for question: QKQuestion) -> String? {
        if(responsesDetail[question] != nil){
            return responsesDetail[question]
        }else{
            return nil
        }
    }
    
}
