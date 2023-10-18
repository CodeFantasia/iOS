//
//  CustomAlert.swift
//  CodeFantasia
//
//  Created by Hyunwoo Lee on 2023/10/18.
//
import UIKit
import SnapKit

class CustomAlertView: UIView {
    
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let actionButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(title: String, message: String, buttonTitle: String) {
        titleLabel.text = title
        messageLabel.text = message
        actionButton.setTitle(buttonTitle, for: .normal)
    }
    func setupAlertViewUI(cornerValue: CGFloat, background: UIColor) {
        self.layer.cornerRadius = cornerValue
        self.backgroundColor = background
    }
}

extension CustomAlertView {
    func totalSetup(title: String, message: String, buttonTitle: String) {
        setupCustomAlertView()
        setupTitleLabel(title: title)
        setupMessageLabel(message: message)
        setupActionButton(buttonTitle: buttonTitle)
        setupLayout()
    }
    func setupCustomAlertView() {
        setupAlertViewUI(cornerValue: 16, background: .white)
        self.backgroundColor = .white
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        self.layer.shadowColor = UIColor.black.cgColor
    }
    func setupTitleLabel(title: String) {
        titleLabel.textAlignment = .center
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
    }
    func setupMessageLabel(message: String) {

        messageLabel.textAlignment = .center
        messageLabel.text = message
        messageLabel.font = .systemFont(ofSize: 20, weight: .regular)
        messageLabel.numberOfLines = 2
    }
     func setupActionButton(buttonTitle: String) {
         actionButton.tintColor = .white
         actionButton.setTitleColor(.black, for: .normal)
         actionButton.setTitle(buttonTitle, for: .normal)
         actionButton.titleLabel?.textAlignment = .center
         actionButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
         actionButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
    }
    @objc func dismissAlert() {
        self.removeFromSuperview()
    }
    func setupLayout() {
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(actionButton)
        
        self.snp.makeConstraints {
            $0.width.equalTo(320)
            $0.height.equalTo(220)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self).offset(20)
            $0.leading.trailing.equalTo(self).inset(20)
        }
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(self).inset(20)
        }
        actionButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(self).inset(20)
            $0.bottom.equalTo(self).inset(20)
        }
    }
}
