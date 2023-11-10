//
//  MyProjectTableViewCell.swift
//  CodeFantasia
//
//  Created by Hyunwoo Lee on 2023/10/17.
import UIKit
import SnapKit
import Then

class MyProjectTableViewCell: UITableViewCell {
    
    static let identifier = "CustomCell"
    
    let projectImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = .cornerRadius
    }
    
    let projectTitle = UILabel().then {
        $0.font = UIFont.subTitle
    }
    
    let projectDescription = UILabel().then {
        $0.numberOfLines = 2
        $0.font = UIFont.body
    }
    
    let dateView = UIView().then {
        $0.layer.cornerRadius = .cornerRadius
        $0.layer.masksToBounds = false
    }
    
    let dateLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: .content, weight: .regular)
        $0.textColor = .white
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        contentView.backgroundColor = .white
    }
}

extension MyProjectTableViewCell {

    func setupCellLayout() {
        
        contentView.addSubview(projectImage)
        contentView.addSubview(projectTitle)
        contentView.addSubview(projectDescription)
        contentView.addSubview(dateView)
        dateView.addSubview(dateLabel)
        
        projectImage.snp.makeConstraints {
            $0.leading.top.equalTo(contentView).offset(16)
            $0.width.height.equalTo(150)
        }
        projectTitle.snp.makeConstraints {
            $0.leading.equalTo(projectImage)
            $0.height.equalTo(20)
            $0.top.equalTo(projectImage.snp.bottom).offset(16)
        }
        projectDescription.snp.makeConstraints {
            $0.leading.equalTo(projectImage)
            $0.top.equalTo(projectTitle.snp.bottom).offset(16)
            $0.bottom.equalTo(contentView.snp.bottom).inset(16)
        }
        dateView.snp.makeConstraints {
            $0.top.trailing.equalTo(contentView).inset(16)
            $0.width.equalTo(50)
            $0.height.equalTo(30)
        }
        dateLabel.snp.makeConstraints {
            $0.edges.equalTo(dateView)
        }
    }
}
