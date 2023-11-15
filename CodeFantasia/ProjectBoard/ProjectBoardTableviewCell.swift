
//
// ProjectBoardTableviewCell.swift
// CodeFantasia
//
// Created by 서영덕
//

import UIKit
import SnapKit
import Then
struct IconModel {
  let image: UIImage
}

class ProjectBoardTableviewCell: UITableViewCell {
  let titleImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 8
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
    $0.layer.cornerRadius = 8
    $0.textColor = .white
    $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    $0.layer.masksToBounds = true // false로 하면 그림자가 생김
    $0.layer.shadowColor = UIColor.black.cgColor // 그림자 색
    $0.layer.shadowOffset = CGSize(width: 5, height: 5) // 그림자 방향
    $0.layer.shadowOpacity = 0.5 // 그림자 크기
    $0.layer.shadowRadius = 1 // 그림자 흐림 정도
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
    let verticalInset: CGFloat = 6
    let horizontalInset: CGFloat = 20
    contentView.frame = CGRect(
      x: horizontalInset,
      y: verticalInset,
      width: bounds.width - (2 * horizontalInset),
      height: bounds.height - (2 * verticalInset)
    )
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
    titleImageView.snp.makeConstraints { make in
      make.right.equalToSuperview().offset(-10)
      make.top.equalToSuperview().offset(10)
      make.width.equalTo(100)
      make.height.equalTo(100)
    }
      
    titleLabel.snp.makeConstraints { (make) in
      make.right.equalTo(titleImageView.snp.left).offset(-10)
      make.top.equalToSuperview().offset(10)
      make.left.equalToSuperview().offset(10)
      make.height.equalTo(30)
    }
      
    subheadingLabel.snp.makeConstraints { (make) in
      make.left.equalTo(titleLabel)
      make.right.equalTo(titleLabel)
      make.top.equalTo(titleLabel.snp.bottom).offset(5)
      make.bottom.equalTo(recruitmentLabel.snp.top).offset(-5)
      make.width.equalTo(230)
    }
      
    recruitmentLabel.snp.makeConstraints { (make) in
      make.left.equalTo(titleLabel)
      make.top.equalTo(subheadingLabel.snp.bottom).offset(25)
      make.width.equalTo(50)
      make.height.equalTo(20)
      make.bottom.equalTo(contentView).offset(-45)
    }
      
    recruitStatusLabel.snp.makeConstraints { (make) in
      make.right.equalTo(titleImageView).offset(0)
      make.bottom.equalTo(contentView).offset(-13)
      make.height.equalTo(26)
      make.width.equalTo(60)
    }
  }
    
  func setViewProperties() {
//    contentView.layer.cornerRadius = 8
//    contentView.layer.shadowColor = UIColor.black.cgColor
//    contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
//    contentView.layer.shadowOpacity = 0.5
//    contentView.layer.shadowRadius = 4
  }
}

// MARK: - Icon Layout

private extension ProjectBoardTableviewCell {
  func updateIconLayout() {
    contentView.subviews.forEach { view in
      if view is UIStackView {
        view.removeFromSuperview()
      }
    }
      
    let iconSize: CGFloat = 30
    let maxIconCount = 5
    var iconViews: [UIImageView] = []
    var iconsToShow = Array(icons.prefix(maxIconCount))
    if icons.count > maxIconCount {
      let moreIcon = IconModel(image: UIImage(named: "MoreDefault") ?? UIImage())
      iconsToShow.append(moreIcon)
    }
    for icon in iconsToShow {
      let iconView = UIImageView(image: icon.image).then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
      }
      iconView.snp.makeConstraints { make in
        make.height.equalTo(iconSize)
        make.width.equalTo(iconSize)
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
      make.height.equalTo(iconSize)
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
