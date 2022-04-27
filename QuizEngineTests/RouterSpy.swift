//
//  RouterSpy.swift
//  QuizEngineTests
//
//  Created by Sai Pasumarthy on 25/04/22.
//

import Foundation
import QuizEngine

class RouterSpy: Router {
    var routedQuestions: [String] = []
    var answerCallback:(String) -> Void = {_ in }
    var routedResult:Result<String, String>?
    
    func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
        routedQuestions.append(question)
        self.answerCallback = answerCallback
    }
    
    func routeTo(result:Result<String, String>) {
        routedResult = result
    }
}
