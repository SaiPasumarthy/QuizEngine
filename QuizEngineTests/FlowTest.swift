//
//  FlowTest.swift
//  QuizEngineTests
//
//  Created by Sai Pasumarthy on 20/04/22.
//

import Foundation
import XCTest
@testable import QuizEngine

class FlowTest: XCTestCase {
    private let delegate = DelegateSpy()

    func test_start_withNoQuestions_doesNotDelegateQuestionHandling() {
        makeSUT(questions: []).start()
        XCTAssertTrue(delegate.handledQuestions.isEmpty)
    }
    
    func test_start_withOneQuestion_delegatesCorrectQuestionHandling() {
        makeSUT(questions: ["Q1"]).start()
        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func test_start_withOneQuestion_delegatesAnotherCorrectQuestionHandling() {
        makeSUT(questions: ["Q2"]).start()
        XCTAssertEqual(delegate.handledQuestions, ["Q2"])
    }
    
    func test_start_withTwoQuestions_delegatesFirstQuestionHandling() {
        makeSUT(questions: ["Q1","Q2"]).start()
        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_delegatesFirstQuestionHandlingTwice() {
        let flow = makeSUT(questions: ["Q1","Q2"])
        flow.start()
        flow.start()
        XCTAssertEqual(delegate.handledQuestions, ["Q1","Q1"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_delegatesSecondAndThirdQuestionHandling() {
        let sut = makeSUT(questions: ["Q1","Q2","Q3"])
        sut.start()
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        XCTAssertEqual(delegate.handledQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestions_doesNotDelegateAnotherQuestionHandling() {
        let sut = makeSUT(questions: ["Q1"])
        sut.start()
        delegate.answerCallback("A1")
        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }

    func test_start_withNoQuestions_delegatesResultHandling() {
        makeSUT(questions: []).start()
        XCTAssertEqual(delegate.handledResult!.answers, [:])
    }
    
    func test_start_withOneQuestion_doesNotDelegateResultHandling() {
        makeSUT(questions: ["Q1"]).start()
        XCTAssertNil(delegate.handledResult)
    }
    
    func test_startAndAnswerFirst_withTwoQuestions_doesNotDelegateResultHandling() {
        let sut = makeSUT(questions: ["Q1","Q2"])
        sut.start()
        delegate.answerCallback("A1")
        XCTAssertNil(delegate.handledResult)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_delegatesResultHandling() {
        let sut = makeSUT(questions: ["Q1","Q2"])
        sut.start()
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        XCTAssertEqual(delegate.handledResult!.answers, ["Q1":"A1", "Q2":"A2"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_scores() {
        let sut = makeSUT(questions: ["Q1","Q2"]) { _ in 10 }
        sut.start()
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        XCTAssertEqual(delegate.handledResult!.score, 10)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_scoreWithRightAnswers() {
        var receivedAnswers:[String: String] = [:]
        let sut = makeSUT(questions: ["Q1","Q2"]) { answers in
            receivedAnswers = answers
            return 20
        }
        sut.start()
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        XCTAssertEqual(delegate.handledResult!.answers, receivedAnswers)
    }
    
    // MARK: Helpers
    
    
    private func makeSUT(questions:[String], scoring: @escaping ([String: String]) -> Int = {_ in 0}) -> Flow<String, String, DelegateSpy> {
        return Flow(questions: questions, router: delegate, scoring: scoring)
    }
    
    private class DelegateSpy: Router, QuizDelegate {
        var handledQuestions: [String] = []
        var answerCallback:(String) -> Void = {_ in }
        var handledResult:Result<String, String>?
        
        func handle(question: String, answerCallback: @escaping (String) -> Void) {
            handledQuestions.append(question)
            self.answerCallback = answerCallback
        }
        
        func handle(result: Result<String, String>) {
            handledResult = result
        }
        
        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            handle(question: question, answerCallback: answerCallback)
        }
        
        func routeTo(result:Result<String, String>) {
            handle(result: result)
        }
    }
}


