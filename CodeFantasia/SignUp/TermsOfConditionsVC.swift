
import UIKit
import Foundation

class TermsOfConditionsVC: UIViewController {
    
    private let termsOfConditionsString = """
Yeah, I'm out that Brooklyn, now I'm down in Tribeca
Right next to De Niro, but I'll be hood forever
I'm the new Sinatra, and since I made it here
I can make it anywhere, yeah, they love me everywhere
I used to cop in Harlem, hola, my Dominicanos (dímelo)
Right there up on Broadway, brought me back to that McDonald's
Took it to my stashbox, 560 State Street
Catch me in the kitchen like a Simmons whippin' pastry
Cruisin' down 8th St, off-white Lexus
Drivin' so slow, but BK is from Texas
Me, I'm out that Bed-Stuy, home of that boy Biggie
Now I live on Billboard and I brought my boys with me
Say what up to Ty-Ty, still sippin' Mai Tais
Sittin' courtside, Knicks and Nets give me high five
Nigga, I be Spike'd out, I could trip a referee (come on, come on, come on)
Tell by my attitude that I'm most definitely from
In New York (ayy, ah-ha) (uh, yeah)
Concrete jungle (yeah) where dreams are made of
There's nothin' you can't do (yeah) (okay)
Now you're in New York (ah-ha, ah-ha, ah-ha) (uh, yeah)
These streets will make you feel brand new (new)
Big lights will inspire you (come on) (okay)
Let's hear it for New York (you're welcome, OG) (uh)
New York (yeah), New York (uh) (I made you hot, nigga)

Catch me at the X with OG at a Yankee game
Shit, I made the Yankee hat more famous than a Yankee can
You should know I bleed blue, but I ain't a Crip though
But I got a gang of niggas walkin' with my clique though
Welcome to the melting pot, corners where we sellin' rock
Afrika Bambataa shit, home of the hip-hop
Yellow cab, gypsy cab, dollar cab, holla back
For foreigners it ain't fair, they act like they forgot how to act
Eight million stories, out there in the naked
City is a pity, half of y'all won't make it
Me, I got a plug, Special Ed, "I Got It Made"
If Jeezy's payin' Lebron, I'm payin' Dwyane Wade
Three dice Cee-lo, three-card Monte
Labor Day Parade, rest in peace Bob Marley
Statue of Liberty, long live the World Trade (come on, come on, come on)
Long live the king, yo, I'm from the Empire State that's
In New York (ayy) (uh, yeah)
Concrete jungle (yeah) where dreams are made of
There's nothin' you can't do (that boy good) (okay)
Now you're in New York (uh, yeah)
(Welcome to the bright lights, baby)
These streets will make you feel brand new
Big lights will inspire you (okay)
Let's hear it for New York (uh)
New York (yeah), New York (uh)
"""
    
    // MARK: Properties
    private let titleLabel = {
        let label = UILabel()
        label.text = "약관 정보 동의"
        label.font = UIFont.systemFont(ofSize: CGFloat.title, weight: .bold)
        
        return label
    }()
    
    private lazy var termsOfConditionsView = {
        let containerView = UIScrollView()
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 1.0
        containerView.layer.cornerRadius = CGFloat.cornerRadius
        
        let label = UILabel()
        label.text = termsOfConditionsString
        label.font = UIFont.systemFont(ofSize: CGFloat.content, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        
        containerView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.edges.equalTo(containerView).inset(10)
            make.width.equalTo(containerView).inset(10)
        }
        
        return containerView
    }()
    
    private let profileRegisterButton = {
        let button = UIButton()
        button.customConfigure(title: "동의하고 프로필 등록하러가기")
        
        return button
    }()
    
    private let consentCheckView = {
        let containerView = UIView()
        
        let label = UILabel()
        label.text = "약관에 동의합니다."
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: CGFloat.subtitle, weight: .light)
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .highlighted)
        
        containerView.addSubview(button)
        containerView.addSubview(label)
        
        button.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(button.snp.trailing).offset(2)
            make.centerY.equalTo(button)
        }
        
        return containerView
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layerConfiguration()
    }
    
    // MARK: Layer Configuration
    private func layerConfiguration() {
        view.addSubview(titleLabel)
        view.addSubview(termsOfConditionsView)
        view.addSubview(profileRegisterButton)
        view.addSubview(consentCheckView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalToSuperview()
        }
        
        termsOfConditionsView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(CGFloat.spacing)
            make.width.equalToSuperview().inset(CGFloat.spacing)
            make.bottom.equalToSuperview().offset(-150)
        }
        
        consentCheckView.snp.makeConstraints { make in
            make.top.equalTo(termsOfConditionsView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.leading.equalTo(termsOfConditionsView)
        }
        
        profileRegisterButton.snp.makeConstraints { make in
            make.top.equalTo(consentCheckView.snp.bottom).offset(20)
            make.width.equalTo(termsOfConditionsView)
            make.leading.trailing.equalTo(consentCheckView)
            make.height.equalTo(35)
        }
    }
}
