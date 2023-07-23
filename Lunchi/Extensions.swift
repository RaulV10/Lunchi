//
//  Extensions.swift
//  Lunchi
//
//  Created by Raul Villarreal on 22/07/23.
//

import Foundation

extension Array {
    func jsonString() throws -> String {
        let jsonData = try JSONSerialization.data(withJSONObject: self)
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            throw NSError(domain: "JSONSerializationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert array to JSON string"])
        }
        return jsonString
    }
}

extension String {
    func jsonObject<T>() throws -> T {
        guard let jsonData = self.data(using: .utf8) else {
            throw NSError(domain: "JSONSerializationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert JSON string to data"])
        }
        return try JSONSerialization.jsonObject(with: jsonData) as! T
    }
}
