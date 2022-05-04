//
//  Question.swift
//  QuizApp
//
//  Created by Sai Pasumarthy on 26/04/22.
//

import Foundation

public enum Question<T: Hashable>: Hashable {
    case singleAnswer(T)
    case multipleAnswer(T)
}
