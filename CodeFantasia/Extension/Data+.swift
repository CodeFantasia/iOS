//
//  Data+.swift
//  CodeFantasia
//
//  Created by hong on 2023/10/20.
//

import Foundation

extension Data {
    func toObject<T: Decodable>(_ type: T.Type) -> T? {
        do {
            return try JSONDecoder().decode(type, from: self)
        } catch {
            print(error)
            return nil
        }
    }
}
