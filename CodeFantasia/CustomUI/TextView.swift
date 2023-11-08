//
//  TextView.swift
//  CodeFantasia
//
//  Created by Daisy Hong on 2023/11/02.
//

import UIKit
import SnapKit

class TextView: UITextView {
    
    // MARK: - Properties
    
    var placeholder: String?
    
    private let accessoryView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let toolbar: UIToolbar = {
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
    
    // MARK: - Init
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.delegate = self
        createToolBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func createToolBar() {
        print("Toolbar 소환됨")
        self.inputAccessoryView = toolbar
    }
    
    func placeholder(withPlaceholder placeholder: String?) {
        if let placeholder = placeholder {
            self.text = placeholder
            self.textColor = .darkGray
            self.font = UIFont.body
            self.placeholder = placeholder
        }
    }
    
    // MARK: - Selectors
    
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
