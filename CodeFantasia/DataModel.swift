//
//  DataModel.swift
//  CodeFantasia
//
//  Created by 서영덕 on 10/18/23.
//

import Foundation

// 사용자 프로필 정보를 나타내는 구조체
struct UserProfile: Codable {
    let nickname: String
    let primaryLanguage: [String]
    let techStack: [TechStack]
    let areasOfInterest: [AreasOfInterest]
    let portfolioURL: String?
    let selfIntroduction: String?
    let githubURL: String?
    let blogURL: String?
    let profileImageURL: String?
    let userProjects: [String]
    let userID: UUID
}

struct Project {
    var techStack: [TechStack]
    var recruitmentCount: Int
    var projectDescription: String?
    var projectDuration: String?
    var meetingType: String?
    var imageUrl: String?
    var projectID: UUID
    var platform: [Platform]
    var recruitmentField: String?
}

// 기술 스택
enum TechCategory: String, Codable {
    case frontendDevelopment
    case backendDevelopment
    case databases
    case servers
    case cloudAndDeployment
    case versionControl
    case programmingLanguages
    case dataAnalysisAndMachineLearning
    case webFrameworksAndLibraries
    case databaseORM
    case frontendLibrariesAndFrameworks
    case testingFrameworks
}

struct TechStack: Codable {
    private var techDictionary: [TechCategory: [String]] = [
        .frontendDevelopment: ["HTML", "CSS", "JavaScript", "React", "Angular", "Vue.js"],
        .backendDevelopment: ["Node.js", "Java", "Python", "Ruby on Rails", "PHP", ".NET", "Spring"],
        .databases: ["MySQL", "PostgreSQL", "MongoDB", "Oracle", "SQLite"],
        .servers: ["Apache", "Nginx", "Tomcat"],
        .cloudAndDeployment: ["Amazon Web Services (AWS)", "Microsoft Azure", "Google Cloud Platform (GCP)", "Docker", "Kubernetes", "Heroku"],
        .versionControl: ["Git", "GitHub", "GitLab"],
        .programmingLanguages: ["Python", "Java", "C++", "C#", "JavaScript", "Ruby", "Swift", "Kotlin", "Go", "Rust"],
        .dataAnalysisAndMachineLearning: ["TensorFlow", "PyTorch", "scikit-learn", "Pandas", "NumPy"],
        .webFrameworksAndLibraries: ["Flask", "Django", "Express.js", "Ruby on Rails", "Spring Boot"],
        .databaseORM: ["SQLAlchemy", "Hibernate", "ActiveRecord"],
        .frontendLibrariesAndFrameworks: ["Bootstrap", "Material-UI", "Foundation", "Semantic UI"],
        .testingFrameworks: ["JUnit", "pytest", "Jasmine", "Jest"]
    ]
    
    // 함수를 사용하여 각 카테고리에 해당하는 기술들을 반환합니다.
    func techForCategory(_ category: TechCategory) -> [String]? {
        return techDictionary[category]
    }
}

enum AreasOfInterest: String, Codable {
    case iOSDevelopment = "iOS 개발"
    case AndroidDevelopment = "Android 개발"
    case WebDevelopment = "웹 개발"
    case BackendDevelopment = "백엔드 개발"
    case DataScienceAndMachineLearning = "데이터 과학 및 머신 러닝"
    case GameDevelopment = "게임 개발"
    case DesktopApplicationDevelopment = "데스크톱 애플리케이션 개발"
    case CloudApplicationDevelopment = "클라우드 애플리케이션 개발"
    case NetworkAndSystemAdministration = "네트워크 및 시스템 관리"
    case SecurityAndCybersecurity = "보안 및 사이버 보안"
    case ArtificialIntelligenceAndMachineLearning = "인공 지능 및 기계 학습"
    case MobileApplicationDevelopment = "모바일 애플리케이션 개발"
    case DatabaseManagementAndAdministration = "데이터베이스 관리 및 관리"
    case WebDesignAndFrontendDevelopment = "웹 디자인 및 프론트엔드 개발"
    case RoboticsAndAutomation = "로봇 공학 및 자동화"
    case BlockchainAndCryptocurrencyDevelopment = "블록체인 및 암호 화폐 개발"
}

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
