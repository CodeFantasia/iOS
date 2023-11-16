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

        let containerView = UIView()
        
        let button: UIButton = {
            let btn = UIButton(type: .system)
            btn.setImage(UIImage(systemName: "xmark"), for: .normal)
            btn.tintColor = .black
            return btn
        }()
        
        let title: UILabel = {
            let label = UILabel()
            label.text = "Post"
            label.font = .boldSmallTitle
            return label
        }()
        
        containerView.addSubview(button)
        button.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        containerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        let divider: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(hex: 0xededed)
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
    
    func createInputView(title: String, textfield: UITextField) -> UIView {
        
        let containerView = UIView()
        
        containerView.snp.makeConstraints { make in
            make.height.equalTo(CGFloat.minimumFormHeight + 30)
        }
        
        let label: UILabel = {
            let label = UILabel()
            label.text = title
            label.font = .boldSmallTitle
            return label
        }()
        
        containerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview()
        }
        
        containerView.addSubview(textfield)
        textfield.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }
        
        
        return containerView
    }
    
    func createTextField(placeholder: String) -> UITextField {

        let textfield = UITextField()
        textfield.placeholder = placeholder
        textfield.layer.cornerRadius = 3
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.layer.borderWidth = 0.75
        textfield.createToolBar()
        textfield.addLeftPadding()
        
        textfield.snp.makeConstraints { make in
            make.height.equalTo(CGFloat.minimumFormHeight)
        }

        return textfield
    }
    
    func createTextviewInput(title: String, textview: UITextView, textviewHeight: CGFloat) -> UIView {
        
        let containerView = UIView()
        
        containerView.snp.makeConstraints { make in
            make.height.equalTo(textviewHeight + 30)
        }
        
        let label: UILabel = {
            let label = UILabel()
            label.text = title
            label.font = .boldSmallTitle
            return label
        }()
        
        containerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview()
        }
        
        containerView.addSubview(textview)
        textview.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(textviewHeight)
        }
        
        return containerView
    }
    
    func createTextView(placeholder: String) -> UITextView {
        
        let textview = TextView()
        textview.placeholder(withPlaceholder: placeholder)
        textview.layer.cornerRadius = 3
        textview.layer.borderColor = UIColor.lightGray.cgColor
        textview.layer.borderWidth = 0.75
        
        return textview
    }
    
    func createDatePicker(startdate: UIDatePicker, enddate: UIDatePicker) -> UIView {
        
        let view = UIView()
        
        view.snp.makeConstraints { make in
            make.height.equalTo(70)
        }
        
        let startLabel: UILabel = {
            let label = UILabel()
            label.text = "프로젝트 시작일"
            label.font = .boldSmallTitle
            return label
        }()
        
        let endLabel: UILabel = {
            let label = UILabel()
            label.text = "프로젝트 종료일"
            label.font = .boldSmallTitle
            return label
        }()
        
        let subviews = [startLabel, endLabel, startdate, enddate]
        
        subviews.forEach { subview in
            view.addSubview(subview)
        }

        startdate.snp.makeConstraints { make in
            make.top.equalTo(startLabel)
            make.left.equalTo(startLabel.snp.right).offset(5)
        }

        startLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.centerY.equalTo(startdate)
        }

        enddate.snp.makeConstraints { make in
            make.top.equalTo(endLabel)
            make.left.equalTo(endLabel.snp.right).offset(5)
        }

        endLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(startdate.snp.bottom).offset(5)
            make.centerY.equalTo(enddate)
        }

        return view
    }

}
