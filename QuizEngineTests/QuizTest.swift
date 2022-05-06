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
    
    func test_startQuiz_answerAllQuestions_completesWithAnswers() {
        let delegate = DelegateSpy()

        quiz = Quiz.start(questions: ["Q1", "Q2"], delegate: delegate)

        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")
        
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        assertEqual(a1: delegate.completedQuizzes[0], a2: [("Q1","A1"), ("Q2","A2")])
    }
    
    func test_startQuiz_answerAllQuestionsTwice_completesWithNewAnswers() {
        let delegate = DelegateSpy()

        quiz = Quiz.start(questions: ["Q1", "Q2"], delegate: delegate)

        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")
        
        delegate.answerCompletions[0]("A1-1")
        delegate.answerCompletions[1]("A2-2")
        
        XCTAssertEqual(delegate.completedQuizzes.count, 2)
        assertEqual(a1: delegate.completedQuizzes[0], a2: [("Q1","A1"), ("Q2","A2")])
        assertEqual(a1: delegate.completedQuizzes[1], a2: [("Q1","A1-1"), ("Q2","A2-2")])
    }
}
