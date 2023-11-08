//
//  TextView.swift
//  CodeFantasia
//
//  Created by Daisy Hong on 2023/11/02.
//

import UIKit
import SnapKit

class TextView: UITextView {
    
    var placeholder: String?
    
    private let accessoryView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let confirmButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("확인", for: .normal)
        btn.backgroundColor = .lightGray
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(handleConfirmButton), for: .touchUpInside)
        btn.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        return btn
    }()

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.delegate = self
        accessory()
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
    
    func accessory() {
        accessoryView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(accessoryView.snp.top)
        }
        self.inputAccessoryView = accessoryView
    }
    
    @objc func handleConfirmButton() {
        print("confirmbutton 눌림")
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
