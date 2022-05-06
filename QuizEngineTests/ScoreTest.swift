//
//  ScoreTest.swift
//  QuizEngine
//
//  Created by Sai Pasumarthy on 06/05/22.
//

import Foundation
import XCTest

class ScoreTest: XCTestCase {
    
    func test_noAnswers_scoresZero() {
        let score = BasicScore.score(for: [], compareTo: [])
        XCTAssertEqual(score, 0)
    }
    
    func test_oneWrongAnswer_scoresZero() {
        let score = BasicScore.score(for: ["wrong"], compareTo: ["correct"])
        XCTAssertEqual(score, 0)
    }
    
    func test_oneCorrectAnswer_scoresOne() {
        let score = BasicScore.score(for: ["correct"], compareTo: ["correct"])
        XCTAssertEqual(score, 1)
    }
    
    func test_oneCorrectAnswerOneWrongAnswer_scoresOne() {
        let score = BasicScore.score(for: ["correct 1", "wrong"], compareTo: ["correct 1", "correct 2"])
        XCTAssertEqual(score, 1)
    }
    
    func test_twoCorrectAnswer_scoresTwo() {
        let score = BasicScore.score(for: ["correct 1", "correct 2"], compareTo: ["correct 1", "correct 2"])
        XCTAssertEqual(score, 2)
    }
    
    func test_unEqualAnswers_scoresTwo() {
        let score = BasicScore.score(for: ["correct 1", "correct 2", "another correct answer"], compareTo: ["correct 1", "correct 2"])
        XCTAssertEqual(score, 2)
    }
    
    private class BasicScore {
        
        static func score(for answers: [String], compareTo correctAnswers: [String]) -> Int {
                     
            var score = 0
            
            for (index, answer) in answers.enumerated() {
                if index >= correctAnswers.endIndex {
                    return score
                }
                score += answer == correctAnswers[index] ? 1 : 0
            }
            
            return score
            
        }
    }
}
