//
//  ProjectBoardTableviewCell.swift
//  CodeFantasia
//
//  Created by 서영덕
//

import UIKit
import SnapKit
import Then

struct IconModel {
    let image: UIImage
}

class ProjectBoardTableviewCell: UITableViewCell {
    
    let titleImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }

    let titleLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textColor = .black
    }

    let subheadingLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .gray
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
        $0.textAlignment = .left
    }

    let recruitStatusLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textAlignment = .center
        $0.layer.masksToBounds = true
        $0.textColor = .white
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }

    let recruitmentLabel = UILabel().then {
        $0.text = "모집분야"
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .black
    }
    
    var icons: [IconModel] = [] {
        didSet {
            updateIconLayout()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setLayoutConstraints()
        setViewProperties()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let inset: CGFloat = 6
        contentView.frame = CGRect(x: inset, y: inset, width: bounds.width - (2 * inset), height: bounds.height - (2 * inset))
    }
}

// MARK: - Setup Views
private extension ProjectBoardTableviewCell {
    func setupViews() {
        contentView.addSubview(titleImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subheadingLabel)
        contentView.addSubview(recruitStatusLabel)
        contentView.addSubview(recruitmentLabel)
    }

    func setLayoutConstraints() {
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            titleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleImageView.widthAnchor.constraint(equalToConstant: 100),
            titleImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        titleLabel.snp.makeConstraints { (make) in
            make.right.equalTo(titleImageView.snp.left).offset(-10)
            make.top.equalTo(titleImageView)
            make.left.equalToSuperview().offset(10)
        }
        
        subheadingLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.width.equalTo(230)
            make.height.equalTo(30)
        }
    
        recruitmentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(subheadingLabel.snp.bottom).offset(25)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        
        recruitStatusLabel.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(0)
            make.bottom.equalTo(contentView).offset(-10)
            make.height.equalTo(30)
            make.width.equalTo(60)
        }
    }

    func setViewProperties() {
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowRadius = 4
    }
}

// MARK: - Icon Layout
private extension ProjectBoardTableviewCell {
    func updateIconLayout() {
        contentView.subviews.forEach { view in
            guard view == titleImageView || view == titleLabel || view == subheadingLabel || view == recruitStatusLabel || view == recruitmentLabel || !(view is UIStackView) else {
                view.removeFromSuperview()
                return
            }
        }

        let iconSize: CGFloat = 30
        var iconViews: [UIImageView] = []

        let displayIcons = icons.prefix(5)
        
        for icon in displayIcons {
            let iconView = UIImageView(image: icon.image).then {
                $0.layer.cornerRadius = iconSize / 2
                $0.clipsToBounds = true
            }
            iconView.snp.makeConstraints { make in
                make.width.height.equalTo(iconSize)
            }

            iconViews.append(iconView)
        }

        let stackView = UIStackView(arrangedSubviews: iconViews).then {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.alignment = .center
        }

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalTo(contentView).offset(-10)
        }
    }
}

// MARK: - Public Methods
extension ProjectBoardTableviewCell {
    func recruitmentLabelCheck(imageURL: URL?, title: String, detail: String, icons: [IconModel], status: String) {
        if let validURL = imageURL {
            URLSession.shared.dataTask(with: validURL) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.titleImageView.image = image
                    }
                }
            }.resume()
        }
        
        titleLabel.text = title
        subheadingLabel.text = detail
        self.icons = icons
        recruitStatusLabel.text = status
        if status == "모집 중" {
            recruitStatusLabel.backgroundColor = .black
        } else {
            recruitStatusLabel.backgroundColor = .lightGray
        }
    }
}
