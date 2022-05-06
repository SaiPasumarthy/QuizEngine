//
//  Assertions.swift
//  QuizEngine
//
//  Created by Sai Pasumarthy on 06/05/22.
//

import Foundation
import XCTest

func assertEqual(a1: [(String, String)], a2: [(String, String)], file: StaticString = #filePath, line: UInt = #line) {
    XCTAssertTrue(a1.elementsEqual(a2, by: ==), "\(a1) is not equal \(a2)", file: file, line: line)
}
