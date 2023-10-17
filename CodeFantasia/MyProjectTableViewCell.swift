//
//  MyProjectTableViewCell.swift
//  CodeFantasia
//
//  Created by Hyunwoo Lee on 2023/10/17.
import UIKit
import SnapKit

class MyProjectTableViewCell: UITableViewCell {
    
    static let identifier = "CustomCell"
    
    let projectImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        return image
    }()
    
    let projectTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    let projectSubtitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    let dateView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowRadius = 4
        let inset: CGFloat = 10
        contentView.frame = CGRect(x: inset, y: inset, width: bounds.width - (2 * inset), height: bounds.height - (2 * inset))
        
    }

}

extension MyProjectTableViewCell {
    func setupCellLayout() {
        
        contentView.addSubview(projectImage)
        contentView.addSubview(projectTitle)
        contentView.addSubview(projectSubtitle)
        contentView.addSubview(dateView)
        dateView.addSubview(dateLabel)
        
        projectImage.snp.makeConstraints {
            $0.leading.top.equalTo(contentView).inset(16)
            $0.width.height.equalTo(150)
        }
        projectTitle.snp.makeConstraints {
            $0.leading.equalTo(projectImage)
            $0.top.equalTo(projectImage.snp.bottom).offset(16)
        }
        projectSubtitle.snp.makeConstraints {
            $0.leading.equalTo(projectImage)
            $0.top.equalTo(projectTitle.snp.bottom).offset(8)
            $0.bottom.equalTo(contentView).inset(20)
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
