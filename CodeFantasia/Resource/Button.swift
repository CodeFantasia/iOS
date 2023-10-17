
import UIKit
import Foundation

extension UIButton {

    func customConfigure(title: String) {
        self.setTitle(title, for: .normal)
        self.configuration?.titleAlignment = .center
        
        self.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .regular)
        self.setTitleColor(.black, for: .normal)
        
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 16.0
        self.backgroundColor = UIColor(hexCode: "FFE45E")
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.3
    }
}
