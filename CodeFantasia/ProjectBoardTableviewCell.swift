//
//  ProjectBoardTableviewCell.swift
//  CodeFantasia
//
//  Created by 서영덕
//

import UIKit
import SnapKit

struct IconModel {
    let image: UIImage
}

class ProjectBoardTableviewCell: UITableViewCell {
    
    let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
//        imageView.layer.borderColor = UIColor.black.cgColor
//        imageView.layer.borderWidth = 1.0
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(red: 125/255.0, green: 215/255.0, blue: 184/255.0, alpha: 1.0)
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        return label
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.textColor = .white
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    let recruitmentLabel: UILabel = {
        let label = UILabel()
        label.text = "모집분야"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()
    
    var icons: [IconModel] = [] {
        didSet {
            updateIconLayout()
        }
    }
    
    func bindData(image: UIImage?, title: String, detail: String, icons: [IconModel], status: String) {
        customImageView.image = image
        titleLabel.text = title
        detailLabel.text = detail
        self.icons = icons
        statusLabel.text = status
        if status == "모집 중" {
            statusLabel.backgroundColor = UIColor(red: 240/255.0, green: 196/255.0, blue: 55/255.0, alpha: 1.0)
        } else {
            statusLabel.backgroundColor = .lightGray
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(customImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(recruitmentLabel)
        
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            customImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            customImageView.widthAnchor.constraint(equalToConstant: 100),
            customImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        titleLabel.snp.makeConstraints { (make) in
            make.right.equalTo(customImageView.snp.left).offset(-10)
            make.top.equalTo(customImageView)
            make.left.equalToSuperview().offset(10)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.width.equalTo(230)
            make.height.equalTo(30)
        }
    
        recruitmentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(detailLabel.snp.bottom).offset(25)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        
        statusLabel.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(0)
            make.bottom.equalTo(contentView).offset(-10)
            make.height.equalTo(30)
            make.width.equalTo(60)
        }
        
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("recruitmentLabel isHidden: \(recruitmentLabel.isHidden)")
        print("recruitmentLabel alpha: \(recruitmentLabel.alpha)")
        print("recruitmentLabel frame: \(recruitmentLabel.frame)")
        print("recruitmentLabel bounds: \(recruitmentLabel.bounds)")
        print("recruitmentLabel's superview clipsToBounds: \(recruitmentLabel.superview?.clipsToBounds ?? false)")
        
        let inset: CGFloat = 6
        contentView.frame = CGRect(x: inset, y: inset, width: bounds.width - (2 * inset), height: bounds.height - (2 * inset))
    }
    
    func setView() {
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowRadius = 4
    }
    
    private func updateIconLayout() {
        for subview in contentView.subviews {
            if subview !== customImageView && subview !== titleLabel && subview !== detailLabel && subview !== statusLabel && subview !== recruitmentLabel && (subview is UIImageView || subview is UILabel) {
                subview.removeFromSuperview()
            }
        }
        
        var lastIconView: UIView? = nil
        let iconSize: CGFloat = 30
        for icon in icons {
            let iconView = UIImageView(image: icon.image)
            iconView.layer.cornerRadius = iconSize / 2
            iconView.clipsToBounds = true
            let label = UILabel()
            
            contentView.addSubview(iconView)
            contentView.addSubview(label)
            
            if let last = lastIconView as? UILabel {
                iconView.snp.makeConstraints { make in
                    make.left.equalTo(last.snp.right).offset(10)
                    make.bottom.equalTo(contentView).offset(-10)
                    make.width.height.equalTo(iconSize)
                }
            } else {
                iconView.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(10)
                    make.bottom.equalTo(contentView).offset(-10)
                    make.width.height.equalTo(iconSize)
                }
            }
            
            label.snp.makeConstraints { make in
                make.left.equalTo(iconView.snp.right).offset(5)
                make.centerY.equalTo(iconView)
            }
            
            lastIconView = label
        }
    }
}
