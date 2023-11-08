//
//  UITextField+.swift
//  CodeFantasia
//
//  Created by Daisy Hong on 2023/11/07.
//

import UIKit
import SnapKit

extension UITextField {
    func accessoryView() {
        lazy var accessoryView: UIView = {
            return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 72.0))
        }()
        
        let confirmButton: UIButton = {
            let btn = UIButton(type: .system)
            btn.setTitle("확인", for: .normal)
            btn.backgroundColor = .lightGray
            btn.setTitleColor(.black, for: .normal)
            btn.snp.makeConstraints { make in
                make.height.equalTo(20)
            }
            return btn
        }()
        
        accessoryView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(accessoryView.snp.top)
        }
        self.inputAccessoryView = accessoryView
    }
}
