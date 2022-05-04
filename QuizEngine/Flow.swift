//
//  Flow.swift
//  QuizEngine
//
//  Created by Sai Pasumarthy on 20/04/22.
//

import Foundation

class Flow<R: QuizDelegate> {
    typealias Question = R.Question
    typealias Answer = R.Answer
    
    private let router: R
    private let questions: [Question]
    private var answers:[Question:Answer] = [:]
    private var scoring: ([Question: Answer]) -> Int
    
    init(questions:[Question], router: R, scoring: @escaping ([Question: Answer]) -> Int) {
        self.questions = questions
        self.router = router
        self.scoring = scoring
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.handle(question: firstQuestion, answerCallback: nextCallback(from: firstQuestion))
        } else {
            router.handle(result: result())
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
                router.handle(question: nextQuestion, answerCallback: nextCallback(from: nextQuestion))
            } else {
                router.handle(result: result())
            }
        }
    }
    
    private func result() -> Result<Question, Answer> {
        return Result(answers: answers, score: scoring(answers))
    }
}
