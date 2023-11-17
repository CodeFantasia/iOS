//
//  Palette.swift
//  CodeFantasia
//
//  Created by hong on 2023/10/13.
//

import UIKit

extension UIColor {
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    static let backgroundColor = UIColor(hexCode: "#F5F5F5")
    static let formBackgroundColor = UIColor(hexCode: "#FFFFFF")
    static let primaryColor = UIColor(hexCode: "#67C99D")
    static let buttonPrimaryColor = UIColor.black
    static let buttonSecondaryColor = UIColor(hexCode: "#B4B4B4")
    static let textfieldColor = UIColor(hexCode: "#f2f2f2")

}
