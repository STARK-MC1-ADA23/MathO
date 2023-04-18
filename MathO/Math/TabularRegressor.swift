//
//  TabularRegressor.swift
//  MathO
//
//  Created by Enzu Ao on 12/04/23.
//

#if targetEnvironment(simulator)
#else
import SwiftUI
import TabularData
import CreateML

struct MathTabularRegressor {
    @ObservedObject private var patternViewModel = PatternViewModel()
    private var trainingData = DataFrame()
    
    
    init() {
        trainingData.append(column: Column(name: "Pattern", contents: patternViewModel.patterns.map {$0.pattern}))
        trainingData.append(column: Column(name: "Value", contents: patternViewModel.patterns.map {$0.value}))
    }
    
    func predictData(patterns: [String]) -> [String]{
        if patternViewModel.patterns.isEmpty {
            return []
        }
        
        guard let model = try? MLLinearRegressor(trainingData: trainingData, targetColumn: "Value") else { print("error");return []}
        print("Model")
        print(model)
        
        var resultData = DataFrame()
        resultData.append(column: Column(name:"Pattern", contents: patterns))
        
        print(resultData)
        
        guard let recomendation = try? model.predictions(from: resultData) else { print("error");return []}
        print("Recomendation Pattern")
        resultData.append(column: recomendation)
        let sortedResultData = resultData.sorted(on:"Predictions")
        print(sortedResultData)
        
        var recomendationPatterns: [String] = []
        
        if sortedResultData.rows[0][1]! as! Double > 0 {
            recomendationPatterns = []
        } else {
            recomendationPatterns = [sortedResultData.rows[0][0]! as! String,
                                     sortedResultData.rows[0][0]! as! String,
                                     sortedResultData.rows[1][0]! as! String,
                                     sortedResultData.rows[1][0]! as! String,
                                     sortedResultData.rows[2][0]! as! String,
                                     sortedResultData.rows[2][0]! as! String]
        }
        
        print(recomendationPatterns)
        return recomendationPatterns
    }
}
#endif

//struct MathTabularRegressor {
//    @ObservedObject private var patternViewModel = PatternViewModel()
//    static let fileURL = URL(fileURLWithPath: "math/transform")
//    static private var trainingData = DataFrame()
//    static let valueColumnID = ColumnID("value", Double.self)
//
//
//    init() {
//        MathTabularRegressor.trainingData.append(column: Column(name: "pattern", contents: patternViewModel.patterns.map {$0.pattern}))
//        MathTabularRegressor.trainingData.append(column: Column(name: "value", contents: patternViewModel.patterns.map {$0.value}))
//    }
//
//    static func train() async throws -> some TabularTransformer {
//        try task.write(transformer, to: fileURL)
//        return transformer
//    }
//
//    static func predict(ops: [String]) async throws -> Double {
//        let model = try task.read(from: fileURL)
//        var predictData = DataFrame()
//        predictData.append(column: Column(name: "pattern", contents: ops))
//        let result = try await model(predictData)
//
//        return result[valueColumnID][0]!
//    }
//}
