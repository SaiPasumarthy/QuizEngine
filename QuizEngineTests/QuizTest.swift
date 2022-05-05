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

    private var quiz: Quiz?
    
    func test_startQuiz_zeroOutOfTwo_scoresZero() {
        let delegate = DelegateSpy()

        quiz = Quiz.start(questions: ["Q1", "Q2"], delegate: delegate)

        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")
        
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        assertEqual(a1: delegate.completedQuizzes[0], a2: [("Q1","A1"), ("Q2","A2")])
    }

    private func assertEqual(a1: [(String, String)], a2: [(String, String)], file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(a1.elementsEqual(a2, by: ==), "\(a1) is not equal \(a2)", file: file, line: line)
    }
    
    private class DelegateSpy: QuizDelegate {
        var answerCompletion:(String) -> Void = {_ in }
        var completedQuizzes: [[(question: String, answer: String)]] = []
        
        func answer(for question: String, completion: @escaping (String) -> Void) {
            self.answerCompletion = completion
        }
        
        func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
            self.completedQuizzes.append(answers)
        }
        
        func handle(result: Result<String, String>) { }
    }
}
