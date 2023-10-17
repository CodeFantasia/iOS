
import UIKit

extension UITextField {
    
    func customConfigure(placeholder: String) {
        self.placeholder = placeholder
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.gray.cgColor
    }
}
