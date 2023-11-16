//
//  NewpostUtilities.swift
//  CodeFantasia
//
//  Created by Daisy Hong on 2023/11/16.
//

import UIKit
import SnapKit

class NewpostUtilities {
    
    func createNavbar() -> (UIButton, UIView) {

        let containerView: UIView = {
            let view = UIView()
            return view
        }()
        
        let button: UIButton = {
            let btn = UIButton(type: .system)
            btn.setImage(UIImage(systemName: "xmark"), for: .normal)
            btn.tintColor = .black
            return btn
        }()
        
        let title: UILabel = {
            let label = UILabel()
            label.text = "새 글 작성"
            label.font = .body
            return label
        }()
        
        containerView.addSubview(button)
        button.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        let divider: UIView = {
            let view = UIView()
            view.backgroundColor = .lightGray
            return view
        }()
        
        containerView.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.height.equalTo(0.75)
            make.width.equalToSuperview()
            make.top.equalTo(containerView.snp.bottom)
        }
        
        
        return (button, containerView)
    }
    
    func createInputView() {
        
    }
}
