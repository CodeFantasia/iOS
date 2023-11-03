//
//  TextView.swift
//  CodeFantasia
//
//  Created by Daisy Hong on 2023/11/02.
//

import UIKit

class TextView: UITextView {
    
    var placeholder: String?

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func placeholder(withPlaceholder placeholder: String?) {
        if let placeholder = placeholder {
            self.text = placeholder
            self.textColor = .darkGray
            self.font = UIFont.body
            self.placeholder = placeholder
        }
    }
}

extension TextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let text = self.text {
            if text == self.placeholder {
                self.text = nil
                self.textColor = .black
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let text = self.text {
            if text.isEmpty {
                self.text = placeholder
                self.textColor = .darkGray
                self.font = UIFont.body
            }
        }
    }
}
