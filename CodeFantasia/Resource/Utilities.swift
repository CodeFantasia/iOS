
import UIKit
import SnapKit

class Utilities {
    
    func inputContainerView(withImage image: UIImage, textField: UITextField) -> UIView {
        let view = UIView()
        let imageview = UIImageView()
        
        imageview.image = image
        imageview.tintColor = .white

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
        dividerView.backgroundColor = .white
        view.addSubview(dividerView)
        
        dividerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(8)
            make.height.equalTo(0.75)
        }
        
        return view
    }
    
    func textField(withPlaceholder placeholder: String) -> UITextField {
        let textfield = UITextField()
        textfield.font = UIFont.systemFont(ofSize: 16)
        textfield.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        // textfield 입력되는 내용도 하얗게 하는 방법 찾아보기
        return textfield
    }
    
    func attributedButton(_ firstPart: String, _ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])

        attributedTitle.append(NSAttributedString(string: secondPart, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }
    
    func inputFormView(withLabel labelStr: String, firstSectionLength: Int, textfield: UITextField, textfieldHeight: CGFloat?) -> UIView {
        let view = UIView()
        
        let label = UILabel()
        if firstSectionLength == 0 {
            label.text = labelStr
        } else {
            label.configureAttributedString(content: labelStr, sectionLength: firstSectionLength)
        }

        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
        }
        
        view.addSubview(textfield)
        textfield.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(2)
            make.left.equalTo(label)
            if let textfieldHeight = textfieldHeight {
                make.height.equalTo(textfieldHeight)
            } else {
                make.height.equalTo(CGFloat.minimumFormHeight)
            }
        }
        
        let dividerView = UIView()
        dividerView.backgroundColor = .lightGray
        view.addSubview(dividerView)
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(textfield.snp.bottom).offset(2)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.75)
        }
        
        return view
    }
}
