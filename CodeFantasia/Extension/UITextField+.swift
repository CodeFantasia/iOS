//
//  UITextField+.swift
//  CodeFantasia
//
//  Created by Daisy Hong on 2023/11/07.
//

import UIKit
import SnapKit

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
    
    func addLeftPadding() {
      let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
      self.leftView = paddingView
      self.leftViewMode = ViewMode.always
    }
    
    func createToolBar() {
        let toolbar: UIToolbar = {
            let toolbar = UIToolbar()
            toolbar.barStyle = .default
            toolbar.items = [
                UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelBtn)),
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDoneBtn))
            ]
            toolbar.sizeToFit()
            return toolbar
        }()
        
        self.inputAccessoryView = toolbar
    }
    
    @objc func handleCancelBtn() {
        print("Cancel 버튼 누름")
        self.resignFirstResponder()
        self.text = placeholder
    }
    
    @objc func handleDoneBtn() {
        print("Done 버튼 누름")
        self.resignFirstResponder()
    }
}
