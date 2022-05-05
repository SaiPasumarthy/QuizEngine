//
//  Quiz.swift
//  QuizEngine
//
//  Created by Sai Pasumarthy on 05/05/22.
//

import Foundation

public final class Quiz {
    private let flow: AnyObject
    
    private init(flow: AnyObject) {
        self.flow = flow
    }
    
    public static func start<Delegate: QuizDelegate>(questions:[Delegate.Question], delegate: Delegate, correctAnswers: [Delegate.Question: Delegate.Answer]) -> Quiz where Delegate.Answer: Equatable {
        let flow = Flow(questions: questions, delegate: delegate, scoring: { scoring(answers: $0, correctAnswers: correctAnswers)})
        flow.start()
        return Quiz(flow: flow)
    }
}

func scoring<Question, Answer: Equatable>(answers: [Question: Answer], correctAnswers: [Question: Answer]) -> Int {
    return answers.reduce(0) { (score, tuple) in
        return score + (correctAnswers[tuple.key] == tuple.value ? 1 : 0)
    }
}
