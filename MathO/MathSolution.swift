//
//  MathSolution.swift
//  MathO
//
//  Created by Enzu Ao on 05/04/23.
//

import Foundation

struct MathSolution{
    let solvingStep: [String]
    let operationStep: String
    let answerOptions: [Int]
    let rightAnswerIndex: Int
    
    init(solvingStep: [String], operationStep: String, answerOptions: [Int], rightAnswerIndex: Int) {
        self.solvingStep = solvingStep
        self.operationStep = operationStep
        self.answerOptions = answerOptions
        self.rightAnswerIndex = rightAnswerIndex
    }
}
