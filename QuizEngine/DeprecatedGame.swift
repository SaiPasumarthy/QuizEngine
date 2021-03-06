//
//  Game.swift
//  QuizEngine
//
//  Created by Sai Pasumarthy on 25/04/22.
//

import Foundation

@available(*, deprecated, message: "use QuizDelegate")
public protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer
    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result:Result<Question, Answer>)
}

@available(*, deprecated, message: "use Quiz")
public class Game<Question, Answer, R: Router> {
    let quiz: Quiz
    init(quiz: Quiz) {
        self.quiz = quiz
    }
}

@available(*, deprecated)
public struct Result<Question: Hashable, Answer> {
    public var answers: [Question: Answer]
    public var score: Int
}

@available(*, deprecated, message: "use Quiz.start")
public func startGame<Question, Answer: Equatable, R: Router>(questions:[Question], router: R, correctAnswers: [Question: Answer]) -> Game<Question, Answer, R> where R.Question == Question, R.Answer == Answer {
    let adapter = QuizDelegateToRouterAdapter(router, correctAnswers)
    let quiz = Quiz.start(questions: questions, delegate: adapter)
    return Game(quiz: quiz)
}

@available(*, deprecated, message: "remove along with deprecated game types")
private class QuizDelegateToRouterAdapter<R: Router> : QuizDelegate where R.Answer: Equatable {
    
    private var router: R
    private let correctAnswers: [R.Question : R.Answer]
    
    init(_ router: R, _ correctAnswers: [R.Question : R.Answer]) {
        self.router = router
        self.correctAnswers = correctAnswers
    }
    
    func answer(for question: R.Question, completion: @escaping (R.Answer) -> Void) {
        router.routeTo(question: question, answerCallback: completion)
    }
    
    func didCompleteQuiz(withAnswers answers: [(question: R.Question, answer: R.Answer)]) {
        let answersDictionary = answers.reduce([R.Question: R.Answer](), { acc, tuple in
            var acc = acc
            acc[tuple.question] = tuple.answer
            return acc
        })
        let score = scoring(answers: answersDictionary, correctAnswers: correctAnswers)
        let result = Result(answers: answersDictionary, score: score)
        router.routeTo(result: result)
    }
        
    private func scoring<Question, Answer: Equatable>(answers: [Question: Answer], correctAnswers: [Question: Answer]) -> Int {
        return answers.reduce(0) { (score, tuple) in
            return score + (correctAnswers[tuple.key] == tuple.value ? 1 : 0)
        }
    }
    
}
