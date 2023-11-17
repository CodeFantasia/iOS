
import UIKit
import SnapKit

class Utilities {
    
    // MARK: - Authentication
    
    func textField(withPlaceholder placeholder: String) -> UITextField {
        let textfield = UITextField()
        textfield.createToolBar()
        textfield.font = UIFont.systemFont(ofSize: 16)
        textfield.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        return textfield
    }
    
    func attributedButton(_ firstPart: String, _ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.black])

        attributedTitle.append(NSAttributedString(string: secondPart, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.blue]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }
    
    func inputContainerView(withImage image: UIImage, textField: UITextField) -> UIView {
        let view = UIView()
        let imageview = UIImageView()
        
        imageview.image = image
        imageview.tintColor = .black

        view.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        view.addSubview(imageview)
        imageview.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview().inset(8)
            make.height.width.equalTo(24)
        }
        
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.left.equalTo(imageview.snp.right).offset(8)
            make.right.bottom.equalToSuperview().inset(8)
        }
        
        let dividerView = UIView()
        dividerView.backgroundColor = .black
        view.addSubview(dividerView)
        
        dividerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(8)
            make.height.equalTo(0.75)
        }
        
        return view
    }
    
    func duplicateCheckView(withImage image: UIImage, textField: UITextField) -> (UIView, UIButton) {
        let view = UIView()
        let imageview = UIImageView()
        let duplicateBtn = UIButton(type: .system)
        duplicateBtn.setTitle("중복확인", for: .normal)
        duplicateBtn.setTitleColor(.white, for: .normal)
        duplicateBtn.backgroundColor = .blue
        duplicateBtn.layer.cornerRadius = .cornerRadius
        
        imageview.image = image
        imageview.tintColor = .black

        view.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        view.addSubview(imageview)
        imageview.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview().inset(8)
            make.height.width.equalTo(24)
        }
        
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.left.equalTo(imageview.snp.right).offset(8)
            make.bottom.equalTo(imageview)
            make.right.equalToSuperview().inset(70)
        }
        
        view.addSubview(duplicateBtn)
        duplicateBtn.snp.makeConstraints { make in
            make.left.equalTo(textField.snp.right).offset(2)
            make.right.bottom.equalToSuperview().inset(5)
        }
        
        let dividerView = UIView()
        dividerView.backgroundColor = .black
        view.addSubview(dividerView)
        
        dividerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(8)
            make.height.equalTo(0.75)
        }
        
        return (view, duplicateBtn)
    }

    // MARK: - Profile
    
    func dropdownInputFormView(withLabel labelStr: String, firstSectionLength: Int, textview: UITextView, textviewHeight: CGFloat?) -> (UIView, UIButton) {
        let view = UIView()
        
        let label = UILabel()
        if firstSectionLength == 0 {
            label.text = labelStr
            label.font = UIFont.subTitle
        } else {
            label.configureAttributedString(content: labelStr, sectionLength: firstSectionLength)
        }

        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
        }
        
        view.addSubview(textview)
        textview.backgroundColor = UIColor.white
        textview.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(2)
            make.left.equalToSuperview()
            make.right.equalToSuperview().offset(-30)
            if let textviewHeight = textviewHeight {
                make.height.equalTo(textviewHeight)
            } else {
                make.height.equalTo(CGFloat.minimumFormHeight)
            }
        }
        
        let dropdownButton = UIButton(type: .system)
        dropdownButton.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        dropdownButton.tintColor = .black
        view.addSubview(dropdownButton)
        dropdownButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(textview)
            make.left.equalTo(textview.snp.right).offset(2)
            make.right.equalToSuperview()
        }
        
        let dividerView = UIView()
        dividerView.backgroundColor = .black
        view.addSubview(dividerView)
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(textview.snp.bottom).offset(2)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.75)
        }
        
        view.snp.makeConstraints { make in
            if let textviewHeight = textviewHeight {
                make.height.equalTo(20 + textviewHeight)
            } else {
                make.height.equalTo(20 + CGFloat.minimumFormHeight)
            }
        }
        
        return (view, dropdownButton)
    }
    
    func inputFormView(withLabel labelStr: String, firstSectionLength: Int, textview: UITextView, textviewHeight: CGFloat?) -> UIView {
        let view = UIView()
        
        let label = UILabel()
        if firstSectionLength == 0 {
            label.text = labelStr
            label.font = UIFont.subTitle
        } else {
            label.configureAttributedString(content: labelStr, sectionLength: firstSectionLength)
        }

        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
        }
        
        view.addSubview(textview)
        textview.backgroundColor = UIColor.white
        textview.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(2)
            make.left.right.equalToSuperview()
            if let textviewHeight = textviewHeight {
                make.height.equalTo(textviewHeight)
            } else {
                make.height.equalTo(CGFloat.minimumFormHeight)
            }
        }
        
        let dividerView = UIView()
        dividerView.backgroundColor = .black
        view.addSubview(dividerView)
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(textview.snp.bottom).offset(2)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.75)
        }
        
        view.snp.makeConstraints { make in
            if let textviewHeight = textviewHeight {
                make.height.equalTo(20 + textviewHeight)
            } else {
                make.height.equalTo(20 + CGFloat.minimumFormHeight)
            }
        }
        
        return view
    }
    
    func termsOfConditionsView(title: String) -> (UIView, UIButton, UIButton) {
        let containerView = UIView()

        let checkboxBtn: UIButton = {
            let btn = UIButton(type: .system)
            btn.setImage(UIImage(systemName: "checkmark"), for: .selected)
            btn.imageView?.contentMode = .scaleAspectFill
            btn.layer.masksToBounds = true
            btn.tintColor = .black
            btn.layer.cornerRadius = 5
            btn.layer.borderColor = UIColor.black.cgColor
            btn.layer.borderWidth = 0.75
            return btn
        }()

        containerView.addSubview(checkboxBtn)
        checkboxBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }

        let label: UILabel = {
            let label = UILabel()
            label.text = title
            label.font = .body
            return label
        }()

        containerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalTo(checkboxBtn.snp.trailing).offset(5)
            make.centerY.equalToSuperview()
        }

        let confirmBtn = UIButton(type: .system)
        confirmBtn.setTitle("확인하기", for: .normal)

        containerView.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.width.equalTo(80)
            make.centerY.equalToSuperview()
        }

        return (containerView, confirmBtn, checkboxBtn)
    }

}
