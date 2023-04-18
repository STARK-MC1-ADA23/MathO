//
//  MathCache.swift
//  MathO
//
//  Created by Enzu Ao on 05/04/23.
//

import Foundation

class PatternAnswerModel: Encodable, Decodable, ObservableObject {
    @Published var id: String
    @Published var pattern: String
    @Published var value: Double
    
    private enum CodingKeys: String, CodingKey {
        case id
        case pattern
        case value
    }
    
    init(pattern: String, value: Double) {
        self.id = UUID().uuidString
        self.pattern = pattern
        self.value = value
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        pattern = try container.decode(String.self, forKey: .pattern)
        value = try container.decode(Double.self, forKey: .value)
    }
    
    func encode(to encoder: Encoder) throws {
        var continer = encoder.container(keyedBy: CodingKeys.self)
        try continer.encode(id, forKey: .id)
        try continer.encode(pattern, forKey: .pattern)
        try continer.encode(value, forKey: .value)
        
    }
}
