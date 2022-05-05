//
//  QuizTest.swift
//  QuizEngine
//
//  Created by Sai Pasumarthy on 05/05/22.
//

import Foundation
import XCTest
@testable import QuizEngine

final class Quiz {
    private let flow: AnyObject
    
    private init(flow: AnyObject) {
        self.flow = flow
    }
    
    static func start<Question, Answer: Equatable, Delegate: QuizDelegate>(questions:[Question], delegate: Delegate, correctAnswers: [Question: Answer]) -> Quiz where Delegate.Question == Question, Delegate.Answer == Answer {
        let flow = Flow(questions: questions, delegate: delegate, scoring: { scoring(answers: $0, correctAnswers: correctAnswers)})
        flow.start()
        return Quiz(flow: flow)
    }
}

class QuizTest: XCTestCase {
    private let delegate = DelegateSpy()
    private var quiz: Quiz!

    override func setUp() {
        super.setUp()
        quiz = Quiz.start(questions: ["Q1", "Q2"], delegate: delegate, correctAnswers: ["Q1":"A1", "Q2":"A2"])
    }
    
    func test_startQuiz_zeroOutOfTwo_scoresZero() {
        
        delegate.answerCallback("wrong")
        delegate.answerCallback("wrong")
        
        XCTAssertEqual(delegate.routedResult!.score, 0)
    }
    
    func test_startQuiz_answerOneOutOfTwo_scoresOne() {
        quiz = Quiz.start(questions: ["Q1", "Q2"], delegate: delegate, correctAnswers: ["Q1":"A1", "Q2":"A2"])
        delegate.answerCallback("A1")
        delegate.answerCallback("wrong")
        
        XCTAssertEqual(delegate.routedResult!.score, 1)
    }
    
    func test_startQuiz_answerTwoOutOfTwo_scoresTwo() {
        quiz = Quiz.start(questions: ["Q1", "Q2"], delegate: delegate, correctAnswers: ["Q1":"A1", "Q2":"A2"])
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.routedResult!.score, 2)
    }
    
    private class DelegateSpy: Router, QuizDelegate {
        var answerCallback:(String) -> Void = {_ in }
        var routedResult:Result<String, String>?
        
        func handle(question: String, answerCallback: @escaping (String) -> Void) {
            self.answerCallback = answerCallback
        }
        
        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            handle(question: question, answerCallback: answerCallback)
        }
        
        func handle(result:Result<String, String>) {
            routedResult = result
        }
        
        func routeTo(result: Result<String, String>) {
            handle(result: result)
        }
    }
}
