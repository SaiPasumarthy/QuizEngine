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
    
    public static func start<Delegate: QuizDelegate>(questions:[Delegate.Question], delegate: Delegate) -> Quiz where Delegate.Answer: Equatable {
        let flow = Flow(questions: questions, delegate: delegate)
        flow.start()
        return Quiz(flow: flow)
    }
}
