//
//  QuizDelegate.swift
//  QuizEngine
//
//  Created by Sai Pasumarthy on 05/05/22.
//

import Foundation

public protocol QuizDelegate {
    associatedtype Question: Hashable
    associatedtype Answer
    
    func answer(for question: Question, completion: @escaping (Answer) -> Void)
    func didCompleteQuiz(withAnswers: [(question: Question, answer: Answer)])
    
    @available(*, deprecated, message: "use didCompleteQuiz method instead")
    func handle(result:Result<Question, Answer>)
}

#warning("Delete is at some point!")
public extension QuizDelegate {
    func didCompleteQuiz(withAnswers: [(question: Question, answer: Answer)]) {
        
    }
}
