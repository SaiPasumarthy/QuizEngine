//
//  DelegateSpy.swift
//  QuizEngine
//
//  Created by Sai Pasumarthy on 06/05/22.
//

import Foundation
import QuizEngine

class DelegateSpy: QuizDelegate {
    var questionsAsked: [String] = []
    var answerCompletions:[(String) -> Void] = []
    var completedQuizzes: [[(question: String, answer: String)]] = []
    
    func answer(for question: String, completion: @escaping (String) -> Void) {
        questionsAsked.append(question)
        self.answerCompletions.append(completion)
    }
    
    func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
        self.completedQuizzes.append(answers)
    }
}
