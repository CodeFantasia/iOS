
import UIKit

extension UILabel {
    
    func configureAttributedString(content: String, sectionLength: Int) {
        let attributedString = NSMutableAttributedString(string: content)
        let stringLength = attributedString.length - 1
        
        attributedString.addAttributes([.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 18, weight: .semibold)], range: NSRange(location: 0, length: sectionLength))
        attributedString.addAttributes([.foregroundColor: UIColor.darkGray, .font: UIFont.systemFont(ofSize: 13, weight: .regular)], range: NSRange(location: sectionLength + 1, length: stringLength - sectionLength))
        
        self.attributedText = attributedString
    }
}
