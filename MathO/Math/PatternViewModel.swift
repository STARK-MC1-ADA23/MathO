//
//  PatternViewModel.swift
//  MathO
//
//  Created by Enzu Ao on 11/04/23.
//

import Foundation

class PatternViewModel: ObservableObject {
    static let shared = PatternViewModel()
    
    private let defaults = UserDefaults.standard
    
    private let key = "patternAnswerList"
    
    var patterns: [PatternAnswerModel] {
        get {
            if let data = defaults.data(forKey: key),
               let patterns = try? JSONDecoder().decode([PatternAnswerModel].self, from: data) {
                return patterns
            }
            return []
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                defaults.set(data, forKey: key)
            }
        }
    }
    
    func addPattern(_ pattern: PatternAnswerModel) {
        patterns.append(pattern)
        self.patterns = patterns
        var i = 0
        print("added \((i+=1))", pattern)
    }
    
    func removeAllPAttern() {
        patterns.removeAll()
        self.patterns = patterns
        print("removedAll")
    }
}
