
import UIKit
import SnapKit

class TermsOfConditionsView: UIView {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Properties
    
    private let termsOfConditions = """
Code Cocoon은(는) \"개인정보 보호법\"에 따라 아래와 같이 수집하는 개인정보의 항목, 수집 및 이용 목적, 보유 및 이용 기간을 안내드리고 동의를 받고자 합니다.

○ 개인정보 수집, 이용 내역

구분(업무명): 회원가입 및 관리
처리목적:
    - 본인 식별 인증
    - 회원자격 유지 관리
    - 각종 고지, 통지사항 전달
    - 서비스 부정가입 및 이용 방지
항목:
    - 이름, 이메일 주소, 아이디, 비밀번호, 닉네임, 휴대전화번호, 프로필 사진
보유 및 이용기간:
    - 회원 탈퇴시까지

구분(업무명): 고객 상담 및 문의
처리목적:
    - 고객 문의 접수 및 처리
    - 고객 불만 사항 처리
    - 문의 접수 및 처리 이력관리
항목:
    - 이름, 휴대전화번호, 이메일주소, 서비스 이용 내역, 문의 내용, 상담 내역, 아이디
보유 및 이용기간:
    - 회원 탈퇴시까지

정보주체는 위와 같이 개인정보를 처리하는 것에 대한 동의를 거부할 권리가 있습니다. 그러나 동의를 거부할 경우 [로그인이 필요한 Code Cocoon 서비스 이용]이 제한될 수 있습니다.
"""
    
    private lazy var textview: UITextView = {
        let textview = UITextView()
        textview.text = termsOfConditions
        textview.textColor = .black
        textview.font = UIFont.body
        textview.isEditable = false
        return textview
    }()
    
    // MARK: - Helpers
    
    func configureUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = .cornerRadius
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 10
        
        self.addSubview(textview)
        textview.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(CGFloat.spacing)
        }
    }
}
