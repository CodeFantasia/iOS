//
//  DataModel.swift
//  CodeFantasia
//
//  Created by 서영덕 on 10/18/23.
//

import UIKit

// 사용자 프로필 정보를 나타내는 구조체
struct UserProfile: Codable {
    let nickname: String
    let techStack: [String]
    let areasOfInterest: [String]
    let portfolioURL: String?
    let selfIntroduction: String?
    let githubURL: String?
    let blogURL: String?
    let profileImageURL: String?
    let userProjects: [String]?
    let userID: UUID
    var blockIDs: [String]?
}
// 신고를 위한 
struct Report {
    let reporterID: String
    let reportedUserID: String
    let description: String
    let date: Date
}

struct UserAuth {
    let email: String
    let password: String
    let name: String
}

struct Project: Codable {
    var projectTitle: String?  // 추가
    var projecSubtitle: String?  // 추가
    var techStack: [TechStack]
    var recruitmentCount: Int
    var projectDescription: String?
    var projectDuration: String?
    var meetingType: String?
    var imageUrl: String?
    var projectID: UUID
    var platform: [Platform]
    var recruitmentField: String?
    var recruitingStatus: Bool?  // 추가 현재 모집중 모집 완료인지
    var teamMember: [TeamMember]
    var contactMethod: String? // 추가
    var writerID: String? // 게시자 아이디
}

//// 기술 스택
//enum TechCategory: String, Codable, CaseIterable {
//    case frontendDevelopment
//    case backendDevelopment
//    case databases
//    case servers
//    case cloudAndDeployment
//    case versionControl
//    case programmingLanguages
//    case dataAnalysisAndMachineLearning
//    case webFrameworksAndLibraries
//    case databaseORM
//    case frontendLibrariesAndFrameworks
//    case testingFrameworks
//}

struct TechStack: Codable {
    var technologies: [String] = [
        "HTML", "CSS", "JavaScript", "React", "Angular", "Vue.js",
        "Node.js", "Java", "Python", "Ruby on Rails", "PHP", ".NET", "Spring",
        "MySQL", "PostgreSQL", "MongoDB", "Oracle", "SQLite",
        "Apache", "Nginx", "Tomcat",
        "Amazon Web Services (AWS)", "Microsoft Azure", "Google Cloud Platform (GCP)", "Docker", "Kubernetes", "Heroku",
        "Git", "GitHub", "GitLab",
        "C++", "C#", "Ruby", "Swift", "Kotlin", "Go", "Rust",
        "TensorFlow", "PyTorch", "scikit-learn", "Pandas", "NumPy",
        "Flask", "Django", "Express.js", "Spring Boot",
        "SQLAlchemy", "Hibernate", "ActiveRecord",
        "Bootstrap", "Material-UI", "Foundation", "Semantic UI",
        "JUnit", "pytest", "Jasmine", "Jest",
        "etc"
    ]
}

    
//    // 함수를 사용하여 각 카테고리에 해당하는 기술들을 반환합니다.
//    func techForCategory(_ category: TechCategory) -> [String]? {
//        return techDictionary[category]
//    }
//}

struct AreasOfInterest: Codable {
    let areasOfInterest: [String] = [
        "iOS 개발",
        "Android 개발",
        "웹 개발",
        "백엔드 개발",
        "데이터 과학 및 머신 러닝",
        "게임 개발",
        "데스크톱 애플리케이션 개발",
        "클라우드 애플리케이션 개발",
        "네트워크 및 시스템 관리",
        "보안 및 사이버 보안",
        "인공 지능 및 기계 학습",
        "모바일 애플리케이션 개발",
        "데이터베이스 관리 및 관리",
        "웹 디자인 및 프론트엔드 개발",
        "로봇 공학 및 자동화",
        "블록체인 및 암호 화폐 개발"
    ]

}

//enum AreasOfInterest: String, Codable {
//    case iOSDevelopment = "iOS 개발"
//    case AndroidDevelopment = "Android 개발"
//    case WebDevelopment = "웹 개발"
//    case BackendDevelopment = "백엔드 개발"
//    case DataScienceAndMachineLearning = "데이터 과학 및 머신 러닝"
//    case GameDevelopment = "게임 개발"
//    case DesktopApplicationDevelopment = "데스크톱 애플리케이션 개발"
//    case CloudApplicationDevelopment = "클라우드 애플리케이션 개발"
//    case NetworkAndSystemAdministration = "네트워크 및 시스템 관리"
//    case SecurityAndCybersecurity = "보안 및 사이버 보안"
//    case ArtificialIntelligenceAndMachineLearning = "인공 지능 및 기계 학습"
//    case MobileApplicationDevelopment = "모바일 애플리케이션 개발"
//    case DatabaseManagementAndAdministration = "데이터베이스 관리 및 관리"
//    case WebDesignAndFrontendDevelopment = "웹 디자인 및 프론트엔드 개발"
//    case RoboticsAndAutomation = "로봇 공학 및 자동화"
//    case BlockchainAndCryptocurrencyDevelopment = "블록체인 및 암호 화폐 개발"
//}

// 출시 플랫폼
enum Platform: String, Codable {
    case iOSAppStore = "iOS App Store (iOS 앱 출시)"
    case GooglePlayStore = "Google Play Store (Android 앱 출시)"
    case WebApplication = "웹 애플리케이션 (웹 브라우저에서 실행)"
    case WindowsStore = "Windows Store (Windows 앱 출시)"
    case MacOSAppStore = "macOS App Store (macOS 앱 출시)"
    case LinuxDistribution = "Linux 배포 (Linux 앱 출시)"
    case PlayStationStore = "PlayStation Store (PlayStation 게임 출시)"
    case XboxLiveMarketplace = "Xbox Live Marketplace (Xbox 게임 출시)"
    case NintendoEshop = "Nintendo eShop (Nintendo 게임 출시)"
    case Steam = "Steam (PC 게임 출시)"
    case OculusStore = "Oculus Store (가상 현실 앱 및 게임 출시)"
    case WebExtensionStore = "웹 확장 프로그램 스토어 (브라우저 확장 프로그램 출시)"
    case CarrierAppStore = "휴대폰 캐리어 앱 스토어 (특정 휴대폰 캐리어에 의한 앱 출시)"
}

struct Role: Codable, Equatable {
    var detailRole: String?
}

struct TeamMember: Codable, Equatable {
    let name: String
    let employeeID: Int
    // 다른 구성원 속성
        var category: Role
}


