//
//  FollowViewCell.swift
//  CodeFantasia
//
//  Created by Hyunwoo Lee on 2023/11/15.
//
import UIKit
import SnapKit
import Then

class FollowViewCell: UITableViewCell {
    
    static let identifier = "FollowCell"
//    var userId: String?
    let followImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = .cornerRadius
    }
    
    let followName = UILabel().then {
        $0.font = UIFont.subTitle
        $0.text = "닉네임"
        $0.textColor = UIColor.black
    }
    
    let followTech = UILabel().then {
        $0.font = UIFont.body
        $0.text = "기술스택"
        $0.textColor = UIColor.black

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

extension FollowViewCell {

    func setupCellLayout() {
        
        contentView.addSubview(followImage)
        contentView.addSubview(followName)
        contentView.addSubview(followTech)

        followImage.snp.makeConstraints {
            $0.leading.top.equalTo(contentView).offset(10)
            $0.width.height.equalTo(100)
        }
        followName.snp.makeConstraints {
            $0.top.equalTo(followImage)
            $0.leading.equalTo(followImage.snp.trailing).offset(10)
            $0.height.equalTo(20)
        }
        followTech.snp.makeConstraints {
            $0.leading.equalTo(followName)
            $0.top.equalTo(followName.snp.bottom).offset(10)
        }
    }
}
