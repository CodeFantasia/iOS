//
//  AutoCompleteManager.swift
//  CodeFantasia
//
//  Created by 서영덕 on 11/14/23.
//

import UIKit
import Foundation

class AutoCompleteManager {
    // 자동완성에 사용될 기술 스택 데이터
    private let allTechStacks: [String]
    
    init() {
        let techStackInstance = TechStack()
        self.allTechStacks = techStackInstance.technologies
    }
    
    // 입력된 텍스트를 기반으로 자동완성 제안을 생성하는 함수
    func generateSuggestions(for text: String) -> [String] {
        return allTechStacks.filter { $0.lowercased().contains(text.lowercased()) }
    }
}
