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
    private var answers:[Question:Answer] = [:]
    private var scoring: ([Question: Answer]) -> Int
    
    init(questions:[Question], delegate: Delegate, scoring: @escaping ([Question: Answer]) -> Int) {
        self.questions = questions
        self.delegate = delegate
        self.scoring = scoring
    }
    
    func start() {
        if let firstQuestion = questions.first {
            delegate.answer(for: firstQuestion, completion: nextCallback(from: firstQuestion))
        } else {
            delegate.handle(result: result())
        }
    }
    
    private func nextCallback(from question: Question) -> (Answer) -> Void {
        return {[weak self] in self?.routeNext(question, $0) }
    }
    
    private func routeNext(_ question: Question, _ answer: Answer) {
        if let currentQuestionIndex = questions.index(of: question) {
            answers[question] = answer
            
            let nextQuestionIndex = currentQuestionIndex + 1
            if nextQuestionIndex < questions.count {
                let nextQuestion = questions[nextQuestionIndex]
                delegate.answer(for: nextQuestion, completion: nextCallback(from: nextQuestion))
            } else {
                delegate.handle(result: result())
            }
        }
    }
    
    private func result() -> Result<Question, Answer> {
        return Result(answers: answers, score: scoring(answers))
    }
}
