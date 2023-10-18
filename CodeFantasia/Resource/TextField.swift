
import UIKit

extension UITextField {
    
    func customConfigure(placeholder: String) {
        self.placeholder = placeholder
        self.layer.cornerRadius = CGFloat.cornerRadius
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.gray.cgColor
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
