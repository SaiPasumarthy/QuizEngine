//
//  QuizTest.swift
//  QuizEngine
//
//  Created by Sai Pasumarthy on 05/05/22.
//

import Foundation
import XCTest
import QuizEngine

class QuizTest: XCTestCase {
    private let delegate = DelegateSpy()
    private var quiz: Quiz!

    override func setUp() {
        super.setUp()
        quiz = Quiz.start(questions: ["Q1", "Q2"], delegate: delegate, correctAnswers: ["Q1":"A1", "Q2":"A2"])
    }
    
    func test_startQuiz_zeroOutOfTwo_scoresZero() {
        
        delegate.answerCompletion("wrong")
        delegate.answerCompletion("wrong")
        
        XCTAssertEqual(delegate.routedResult!.score, 0)
    }
    
    func test_startQuiz_answerOneOutOfTwo_scoresOne() {
        quiz = Quiz.start(questions: ["Q1", "Q2"], delegate: delegate, correctAnswers: ["Q1":"A1", "Q2":"A2"])
        delegate.answerCompletion("A1")
        delegate.answerCompletion("wrong")
        
        XCTAssertEqual(delegate.routedResult!.score, 1)
    }
    
    func test_startQuiz_answerTwoOutOfTwo_scoresTwo() {
        quiz = Quiz.start(questions: ["Q1", "Q2"], delegate: delegate, correctAnswers: ["Q1":"A1", "Q2":"A2"])
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")
        
        XCTAssertEqual(delegate.routedResult!.score, 2)
    }
    
    private class DelegateSpy: QuizDelegate {
        var answerCompletion:(String) -> Void = {_ in }
        var routedResult:Result<String, String>?
        
        func answer(for question: String, completion: @escaping (String) -> Void) {
            self.answerCompletion = completion
        }
     
        func handle(result:Result<String, String>) {
            routedResult = result
        }
    }
}
