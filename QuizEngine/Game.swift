//
//  Game.swift
//  QuizEngine
//
//  Created by Sai Pasumarthy on 25/04/22.
//

import Foundation

@available(*, deprecated)
public class Game<Question, Answer, R: Router> where R.Question == Question, R.Answer == Answer {
    let flow: Flow<Question, Answer, R>
    init(flow: Flow<Question, Answer, R>) {
        self.flow = flow
    }
}

@available(*, deprecated)
public func startGame<Question, Answer: Equatable, R: Router>(questions:[Question], router: R, correctAnswers: [Question: Answer]) -> Game<Question, Answer, R> where R.Question == Question, R.Answer == Answer {
    let flow = Flow(questions: questions, router: router, scoring: { scoring(answers: $0, correctAnswers: correctAnswers)})
    flow.start()
    return Game(flow: flow)
}

private func scoring<Question, Answer: Equatable>(answers: [Question: Answer], correctAnswers: [Question: Answer]) -> Int {
    return answers.reduce(0) { (score, tuple) in
        return score + (correctAnswers[tuple.key] == tuple.value ? 1 : 0)
    }
}
