//
//  Math.swift
//  MathO
//
//  Created by Vincent Gunawan on 30/03/23.
//

import Foundation

let MathPattern: [String] = ["-,+,*",
                             "+,/,-",
                             "-,*,/",
                             "+,-,/",
                             "-,+,*",
                             "+,+,/",
                             "+,-,*",
                             "*,-,+",
                             "/,*,-",
                             "*,+,/",]

struct Math{
    
    let selectedPattern = ["+",":","-","x"]
    let randomQuestion: (number: [Int], parenthesis: [Int]?)
    var stringQuestion: String
    let correctAnswer: Int
    let answerOption: (answerOptions: [Int], rightAnswerIndex: Int?)
    let solution: [MathSolution]
    
    init() {
        self.randomQuestion = Math.GenerateQuestion(opsArr: selectedPattern, isParenthesis: true)
        self.stringQuestion = Math.ShowSolvingStep(numArr: randomQuestion.number, opsArr: selectedPattern, opsIndex: -1, parenthesis: randomQuestion.parenthesis)[0]
        var result = Math.CalculateMixedOperation(numArrPar: randomQuestion.number, opsArrPar: selectedPattern, parenthesis: randomQuestion.parenthesis)
        self.correctAnswer = result.correctAnswer
        self.solution = result.solution
        self.answerOption = Math.GenerateAnswerOptions(numArr: randomQuestion.number, opsArr: selectedPattern, rightAnswer: self.correctAnswer)
    }
        
    static func GenerateQuestion(opsArr: [String], isParenthesis: Bool = false) -> (number: [Int], parenthesis: [Int]?) {
        var numArr = Array(repeating: 0, count: opsArr.count + 1)
        var parenthesis: [Int] = []
        let rangeAddSub = 2..<10
        //    let rangeMulDiv = 2..<10
        var index = 0
        var isDivision = false
        var tempDivisionOperand = 0
        
        if isParenthesis {
            while(true){
                var parenthesisWrap = Int.random(in: 1..<opsArr.count)
                var parenthesisOps = Int.random(in: 0..<opsArr.count-parenthesisWrap)
                while (parenthesisWrap > 0) {
                    parenthesis.append(parenthesisOps)
                    parenthesisOps+=1
                    parenthesisWrap-=1
                }
                if !opsArr.contains(":") {break}
                if let index = opsArr.firstIndex(of: ":") {
                    if parenthesis.contains(index) {break}
                    let gapFromDiv1 = parenthesis[0] - index
                    let gapFromDiv2 = parenthesis[parenthesis.count-1] - index
                    if (gapFromDiv1 != 1) && (gapFromDiv2 != 1) && (gapFromDiv1 != -1) && (gapFromDiv2 != -1){
                        break
                    }
                }
                parenthesis = []
            }
        }
        
        if !opsArr.contains(":") {
            while(opsArr.count + 1 > index) {
                numArr[index] = Int.random(in: rangeAddSub)
                index+=1
            }
            return (numArr, parenthesis)
        }
        
        for ops in opsArr {
            if ops == ":" && opsArr[index-1] == "x" && !isParenthesis{
                numArr[index] = Int.random(in: rangeAddSub)
                var operandDivision = 10
                while operandDivision > 1 {
                    if numArr[index] * numArr[index-1] % operandDivision == 0 && operandDivision != numArr[index] && operandDivision != numArr[index-1]{
                        tempDivisionOperand = operandDivision
                        break
                    }
                    operandDivision-=1
                }
                if operandDivision == 1 {
                    tempDivisionOperand = numArr[index-1]
                }
                isDivision = true
            } else if ops == ":" {
                tempDivisionOperand = Int.random(in: rangeAddSub)
                numArr[index] = Int.random(in: rangeAddSub) * tempDivisionOperand
                isDivision = true
            } else if isDivision {
                numArr[index] = tempDivisionOperand
                isDivision = false
            } else {
                numArr[index] = Int.random(in: rangeAddSub)
            }
            index+=1
        }
        
        if isDivision{
            numArr[index] = tempDivisionOperand
        } else  {
            numArr[index] = Int.random(in: rangeAddSub)
        }
        
        if !isParenthesis {
            return (numArr, nil)
        }
        
        return (numArr, parenthesis)
    }
    
    static func closeRandomWrongAnswer(rightAnswer: Int) -> Int{
        var randomAnswer: [Int] = []
        randomAnswer.append(Int.random(in: rightAnswer-6..<rightAnswer-1))
        randomAnswer.append(Int.random(in: rightAnswer+1..<rightAnswer+6))
        
        return randomAnswer[Int.random(in: 0..<1)]
    }
    
    static func farRandomWrongAnswer(rightAnswer: Int) -> Int{
        var randomAnswer: [Int] = []
        randomAnswer.append(Int.random(in: rightAnswer-50..<rightAnswer-11))
        randomAnswer.append(Int.random(in: rightAnswer+11..<rightAnswer+50))
        
        return randomAnswer[Int.random(in: 0..<1)]
    }
    
    static func wrongCalculate(numArr: [Int], opsArr: [String]) -> Int {
        var wrongAnswer: Int = numArr[0]
        var index: Int = 0
        for ops in opsArr {
            index+=1
            switch(ops){
            case "+":
                wrongAnswer += numArr[index]
                continue
            case "-":
                wrongAnswer -= numArr[index]
                continue
            case "x":
                wrongAnswer *= numArr[index]
                continue
            case ":":
                if wrongAnswer % numArr[index] == 0 {
                    wrongAnswer /= numArr[index]
                } else {
                    wrongAnswer += numArr[index]
                }
                continue
            default: continue
            }
        }
        return wrongAnswer
    }
    
    static func randomPickFunction(_ numArr: [Int],_ opsArr: [String],_ rightAnswer: Int, selectedFunction: Int = 0) -> Int {
        var tempSelected = selectedFunction
        
        if tempSelected == 0 {
            tempSelected = Int.random(in: 1..<3)
        }
        
        switch tempSelected {
        case 1:
            return closeRandomWrongAnswer(rightAnswer: rightAnswer)
        case 2:
            return farRandomWrongAnswer(rightAnswer: rightAnswer)
        case 3:
            return wrongCalculate(numArr: numArr, opsArr: opsArr)
        default:
            return 0
        }
        
    }
    
    static func GenerateAnswerOptions(numArr: [Int] = [], opsArr: [String] = [], rightAnswer: Int) -> (answerOptions: [Int], rightAnswerIndex: Int?) {
        var answerOptions: [Int] = [rightAnswer]
        var answer = 0
        let opsArrCount: Int = opsArr.count
        
        if opsArrCount <= 1 {
            while(true){
                answer = randomPickFunction(numArr, opsArr, rightAnswer, selectedFunction: 1)
                
                if !answerOptions.contains(answer){
                    answerOptions.append(answer)
                }
                
                if answerOptions.count >= 4 { break }
            }
        } else if opsArrCount >= 2 {
            while(true){
                answer = randomPickFunction(numArr, opsArr, rightAnswer)
                
                if !answerOptions.contains(answer){
                    answerOptions.append(answer)
                }
                
                if answerOptions.count >= 4 { break }
            }
        }
        
        let shuffleAnswerOptions: [Int] = answerOptions.shuffled()
        
        return (shuffleAnswerOptions, shuffleAnswerOptions.firstIndex(of: rightAnswer))
    }
    
    static func RemoveParenthesisElement(_ parenthesis: inout [Int],_ value: Int) {
        if var index = parenthesis.firstIndex(of: value) {
            parenthesis.remove(at: index)
            while parenthesis.count > index {
                parenthesis[index]-=1
                index+=1
            }
        }
    }

    static func CalculateOperationMulDiv(_ numArr: inout [Int],_ opsArr: inout [String],_ ops: String,_ index: Int)  -> (show: String, result: Int) {
        let tempN1 = numArr.remove(at: index)
        let tempN2 = numArr.remove(at: index)
        var operation: String = ""
        var result: Int = 0
        
        switch ops {
        case ":":
            result = tempN1 / tempN2
            numArr.insert(result, at: index)
            opsArr.remove(at: index)
            operation = "\(tempN1) : \(tempN2)"
            return (operation, result)
        case "x":
            result = tempN1 * tempN2
            numArr.insert(result, at: index)
            opsArr.remove(at: index)
            operation = "\(tempN1) x \(tempN2)"
            return (operation, result)
        default: return (operation, result)
        }
    }

    static func CalculateOperationAddSub(_ numArr: inout [Int],_ opsArr: inout [String],_ ops: String,_ index: Int) -> (show: String, result: Int) {
        let tempN1 = numArr.remove(at: index)
        let tempN2 = numArr.remove(at: index)
        var operation: String = ""
        var result: Int = 0
        
        switch ops {
        case "-":
            result = tempN1 - tempN2
            numArr.insert(result, at: index)
            opsArr.remove(at: index)
            operation = "\(tempN1) - \(tempN2)"
            return (operation, result)
        case "+":
            result = tempN1 + tempN2
            numArr.insert(result, at: index)
            opsArr.remove(at: index)
            operation = "\(tempN1) + \(tempN2)"
            return (operation, result)
        default: return (operation, result)
        }
    }

    static func ShowSolvingStep(numArr: [Int], opsArr: [String], opsIndex: Int, parenthesis: [Int]? = nil) -> [String] {
        var Operation = ""
        var index = 0
        var pIndex = 0
        var closeParenthesis = false
        var highlightOperation = false
        var splitOperation: [String] = []
        
        for number in numArr {
            if let parenthesis = parenthesis {
                if  parenthesis.count > pIndex && (parenthesis[pIndex] ) == index + pIndex {
                    Operation += "( "
                    pIndex = parenthesis.count - 1
                    closeParenthesis = true
                }
            }
            if index == opsIndex {
                splitOperation.append(Operation)
                Operation = ""
                highlightOperation = true
            }
            Operation += String(number) + " "
            if highlightOperation && index != opsIndex {
                splitOperation.append(Operation)
                Operation = ""
                highlightOperation = false
            }
            Operation += " "
            if let parenthesis = parenthesis {
                if  (parenthesis[pIndex]) == index - 1 {
                    Operation += ") "
                    closeParenthesis = false
                }
            }
            if opsArr.count > index {
                Operation += opsArr[index] + " "
            }
            index+=1
        }
        if closeParenthesis {
            Operation += ")"
        }
        splitOperation.append(Operation)
        return splitOperation
    }

    static func CalculateMixedOperation(numArrPar: [Int], opsArrPar: [String], parenthesis: [Int]? = nil) -> (correctAnswer: Int, solution: [MathSolution]) {
        var numArr = numArrPar
        var opsArr = opsArrPar
        var solvingStep: [String]
        var operation: (show: String, result: Int)
        var randomAnswer: (answerOptions: [Int], rightAnswerIndex: Int?)
        var mathSolutionSteps: [MathSolution] = []
        var index = 0
        
        if var parenthesis = parenthesis {
            for ops in opsArr {
                if (ops == ":" || ops == "x") && parenthesis.contains(index){
                    solvingStep = ShowSolvingStep(numArr: numArr, opsArr: opsArr,opsIndex: index, parenthesis: parenthesis)
                    RemoveParenthesisElement(&parenthesis, index)
                    operation = CalculateOperationMulDiv(&numArr, &opsArr, ops, index)
                    randomAnswer = GenerateAnswerOptions(rightAnswer: operation.result)
                    mathSolutionSteps.append(MathSolution(solvingStep: solvingStep, operationStep: operation.show, answerOptions: randomAnswer.answerOptions, rightAnswerIndex: randomAnswer.rightAnswerIndex!))
                    continue
                }
                index+=1
            }
            
            index = 0
            
            for ops in opsArr {
                if (ops == "-" || ops == "+") && parenthesis.contains(index){
                    solvingStep = ShowSolvingStep(numArr: numArr, opsArr: opsArr,opsIndex: index, parenthesis: parenthesis)
                    RemoveParenthesisElement(&parenthesis, index)
                    operation = CalculateOperationAddSub(&numArr, &opsArr, ops, index)
                    randomAnswer = GenerateAnswerOptions(rightAnswer: operation.result)
                    mathSolutionSteps.append(MathSolution(solvingStep: solvingStep, operationStep: operation.show, answerOptions: randomAnswer.answerOptions, rightAnswerIndex: randomAnswer.rightAnswerIndex!))
                    continue
                }
                index+=1
            }
            
            index = 0
        }
        
        for ops in opsArr {
            if ops == ":" || ops == "x" {
                solvingStep = ShowSolvingStep(numArr: numArr, opsArr: opsArr, opsIndex: index)
                operation = CalculateOperationMulDiv(&numArr, &opsArr, ops, index)
                randomAnswer = GenerateAnswerOptions(rightAnswer: operation.result)
                mathSolutionSteps.append(MathSolution(solvingStep: solvingStep, operationStep: operation.show, answerOptions: randomAnswer.answerOptions, rightAnswerIndex: randomAnswer.rightAnswerIndex!))
                continue
            }
            index+=1
        }
        
        index = 0
        
        for ops in opsArr {
            if ops == "-" || ops == "+" {
                solvingStep = ShowSolvingStep(numArr: numArr, opsArr: opsArr, opsIndex: index)
                operation = CalculateOperationAddSub(&numArr, &opsArr, ops, index)
                randomAnswer = GenerateAnswerOptions(rightAnswer: operation.result)
                mathSolutionSteps.append(MathSolution(solvingStep: solvingStep, operationStep: operation.show, answerOptions: randomAnswer.answerOptions, rightAnswerIndex: randomAnswer.rightAnswerIndex!))
                continue
            }
            index+=1
        }
        
        return (numArr[0], mathSolutionSteps)
    }

}
