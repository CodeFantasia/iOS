//
//  UITextView+.swift
//  CodeFantasia
//
//  Created by Daisy Hong on 2023/11/02.
//

import UIKit

extension UITextView: UITextViewDelegate {
    func placeholder(withPlaceHolder placeholder: String) {
        self.delegate = self
        self.text = placeholder
        self.textColor = .lightGray
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if !self.text.isEmpty {
            self.text = nil
            self.textColor = .black
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if self.text.isEmpty {
            self.text = "placeholder"
            self.textColor = .lightGray
        }
    }
    
}
