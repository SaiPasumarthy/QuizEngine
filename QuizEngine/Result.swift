//
//  Result.swift
//  QuizEngine
//
//  Created by Sai Pasumarthy on 25/04/22.
//

import Foundation

public struct Result<Question: Hashable, Answer> {
    public var answers: [Question: Answer]
    public var score: Int
    
    public init(answers: [Question: Answer], score: Int) {
        self.answers = answers
        self.score = score
    }
    
}