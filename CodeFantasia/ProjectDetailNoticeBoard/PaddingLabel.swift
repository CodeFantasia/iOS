//
//  PaddingLabel.swift
//  CodeFantasia
//
//  Created by hong on 2023/10/13.
//
//

import UIKit

class PaddingLabel: UILabel {
    private var underlineLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        // Add an underline layer
        underlineLayer = CAShapeLayer()
        underlineLayer.fillColor = UIColor.clear.cgColor
        underlineLayer.strokeColor = UIColor.gray.cgColor
        underlineLayer.lineWidth = 0.2
        layer.addSublayer(underlineLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update the frame of the underline layer
        underlineLayer.path = UIBezierPath(rect: CGRect(x: 0, y: bounds.size.height - 1.0, width: bounds.size.width, height: 1.0)).cgPath
    }
}
//import UIKit
//
//class PaddingLabel: UILabel {
//    private var shadowLayer: CAShapeLayer!
//    private var textLayer: CATextLayer!
//    private var cornerRadius: CGFloat = .cornerRadius
//    private var inset: UIEdgeInsets
//    
//    override init(frame: CGRect) {
//        self.inset = .zero
//        super.init(frame: frame)
//    }
//    
//    required init?(coder: NSCoder) {
//        self.inset = .zero
//        super.init(coder: coder)
//    }
//    
//    override func drawText(in rect: CGRect) {
//        super.drawText(in: rect.inset(by: inset))
//    }
//    
//    convenience init(inset: UIEdgeInsets = .zero, cornerRadius: CGFloat = 10.0) {
//        self.init(frame: .zero)
//        self.inset = inset
//    }
//    
//    override var intrinsicContentSize: CGSize {
//        var size = super.intrinsicContentSize
//        size.width += inset.left + inset.right
//        size.height += inset.top + inset.bottom
//        return size
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        if let textLayer {
//            textLayer.removeFromSuperlayer()
//        }
//        if let shadowLayer {
//            shadowLayer.removeFromSuperlayer()
//        }
//          
//        textLayer = CATextLayer()
//        textLayer.frame = CGRect(x: Int(bounds.origin.x+10.0), y: Int(bounds.origin.y+10.0), width: Int(bounds.width-20.0), height: Int(bounds.height-20))
//        textLayer.isWrapped = true
//        textLayer.contentsScale = UIScreen.main.scale
//        textLayer.alignmentMode = .left
//        let attributedString = NSAttributedString(
//            string: text ?? "",
//            attributes: [
//                .font: UIFont.body,
//                .foregroundColor: UIColor.black
//            ]
//        )
//        textLayer.string = attributedString
//        layer.insertSublayer(textLayer, at: 1)
//        
//        shadowLayer = CAShapeLayer()
//        // spread
//        shadowLayer.path = UIBezierPath(roundedRect: bounds.insetBy(dx: 0, dy: 0), cornerRadius: cornerRadius).cgPath
//        shadowLayer.shadowPath = shadowLayer.path
//        shadowLayer.fillColor = UIColor.formBackgroundColor.cgColor
//        // color
//        shadowLayer.shadowColor = UIColor(hexCode: "#000000").cgColor
//        // x, y
//        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 4.0)
//        // opacity
//        shadowLayer.shadowOpacity = 0.11
//        // blur
//        shadowLayer.shadowRadius = 4 / UIScreen.main.scale
//        layer.insertSublayer(shadowLayer, at: 0)
//        
//    }
//    
//}
