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
        delegateQuestionHandling(at: questions.startIndex)
    }
    
    private func delegateQuestionHandling(at index: Int) {
        if index < questions.endIndex {
            let question = questions[index]
            delegate.answer(for: question, completion: answer(for: question, at: index))
        } else {
            delegate.didCompleteQuiz(withAnswers: answers)
        }
    }
    
    private func delegateQuestionHandling(after index: Int) {
        delegateQuestionHandling(at: questions.index(after: index))
    }
    
    private func answer(for question: Question, at index: Int) -> (Answer) -> Void {
        return { [weak self] answer in
            self?.answers.replaceOrInsert((question, answer), index)
            self?.delegateQuestionHandling(after: index)
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
