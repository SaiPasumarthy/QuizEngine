//
//  GameTest.swift
//  QuizEngineTests
//
//  Created by Sai Pasumarthy on 25/04/22.
//

import Foundation
import XCTest
import QuizEngine

class GameTest: XCTestCase {
    let router = RouterSpy()
    var game: Game<String, String, RouterSpy>!

    override func setUp() {
        super.setUp()
        game = startGame(questions: ["Q1", "Q2"], router: router, correctAnswers: ["Q1":"A1", "Q2":"A2"])
    }
    
    func test_startGame_zeroOutOfTwo_scoresZero() {
        
        router.answerCallback("wrong")
        router.answerCallback("wrong")
        
        XCTAssertEqual(router.routedResult!.score, 0)
    }
    
    func test_startGame_answerOneOutOfTwo_scoresOne() {
        game = startGame(questions: ["Q1", "Q2"], router: router, correctAnswers: ["Q1":"A1", "Q2":"A2"])
        router.answerCallback("A1")
        router.answerCallback("wrong")
        
        XCTAssertEqual(router.routedResult!.score, 1)
    }
    
    func test_startGame_answerTwoOutOfTwo_scoresTwo() {
        game = startGame(questions: ["Q1", "Q2"], router: router, correctAnswers: ["Q1":"A1", "Q2":"A2"])
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(router.routedResult!.score, 2)
    }
}
