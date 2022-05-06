//
//  Flow.swift
//  QuizEngine
//
//  Created by Sai Pasumarthy on 20/04/22.
//

import Foundation

class Flow<Delegate: QuizDelegate> {
    typealias Question = Delegate.Question
    typealias Answer = Delegate.Answer
    
    private let delegate: Delegate
    private let questions: [Question]
    private var answers:[(Question,Answer)] = []
    
    init(questions:[Question], delegate: Delegate) {
        self.questions = questions
        self.delegate = delegate
    }
    
    func start() {
        if let firstQuestion = questions.first {
            delegate.answer(for: firstQuestion, completion: nextCallback(from: firstQuestion))
        } else {
            delegate.didCompleteQuiz(withAnswers: answers)
        }
    }
    
    private func nextCallback(from question: Question) -> (Answer) -> Void {
        return {[weak self] in self?.routeNext(question, $0) }
    }
    
    private func routeNext(_ question: Question, _ answer: Answer) {
        if let currentQuestionIndex = questions.index(of: question) {
            answers.replaceOrInsert((question, answer), currentQuestionIndex)
            let nextQuestionIndex = currentQuestionIndex + 1
            if nextQuestionIndex < questions.count {
                let nextQuestion = questions[nextQuestionIndex]
                delegate.answer(for: nextQuestion, completion: nextCallback(from: nextQuestion))
            } else {
                delegate.didCompleteQuiz(withAnswers: answers)
            }
        }
    }
}

extension Array {
    mutating func replaceOrInsert(_ element: Element, _ index: Index) {
        if index < count {
            remove(at: index)
        }
        
        insert(element, at: index)
    }
}
