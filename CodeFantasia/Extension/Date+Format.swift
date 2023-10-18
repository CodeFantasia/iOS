//
//  Date+Format.swift
//  CodeFantasia
//
//  Created by hong on 2023/10/17.
//

import Foundation

extension Date {
    
    private enum DateFormat: String {
        case yearMonthDate = "yyyy.MM.dd"
    }
    
    private func formatted(dateFormat: DateFormat) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = dateFormat.rawValue
        dateFormatter.timeZone = .autoupdatingCurrent
        return dateFormatter
    }
    
    /// 2023.10.17
    var yearMonthDate: String {
        return formatted(dateFormat: .yearMonthDate).string(from: self)
    }
}
