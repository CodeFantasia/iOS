//
//  ProjectRepository.swift
//  CodeFantasia
//
//  Created by hong on 2023/10/20.
//

import Foundation
import RxSwift

protocol ProjectRepositoryProtocol {
    func read(projectId: String) -> Single<Project>
    func readAll() -> Single<[Project]>
    func readBlockAll(blockIDs: [String]) -> Single<[Project]>
    func create(project: Project)
    func delete(project: Project)
    func `delete`(projectId: String)
    func update(project: Project)
    func `update`(project: Project, projectId: String)
}

struct ProjectRepository: ProjectRepositoryProtocol {

    private enum ProjectRepositoryError: LocalizedError {
        case dataConvertError
    }
    
    private let firebaseManager: FireBaseManagerProtocol
    private let collectionId: String
    
    init(
        collectionId: String = "Project",
        firebaseBaseManager: FireBaseManagerProtocol
    ) {
        self.collectionId = collectionId
        self.firebaseManager = firebaseBaseManager
    }
    
    func read(projectId: String) -> Single<Project> {
        return firebaseManager.read(collectionId, projectId)
            .map {
                if let projectData = $0.toObject(Project.self) {
                    return projectData
                } else {
                    throw ProjectRepositoryError.dataConvertError
                }
            }
    }
    
    func readAll() -> Single<[Project]> {
        return firebaseManager.read(collectionId)
            .map { datas in
                return datas.compactMap { $0.toObject(Project.self) }
            }
    }
    
    func readBlockAll(blockIDs: [String]) -> Single<[Project]> {
            return firebaseManager.read(collectionId)
                .map { datas in
                    return datas.compactMap { $0.toObject(Project.self) }.filter{!blockIDs.contains($0.writerID ?? "")
                        
                    }
                }
        }
    
    func create(project: Project) {
        firebaseManager.create(collectionId, project.projectID.uuidString, project)
    }
    
    func delete(project: Project) {
        firebaseManager.delete(collectionId, project.projectID.uuidString)
    }
    
    func `delete`(projectId: String) {
        firebaseManager.delete(collectionId, projectId)
    }
    
    func update(project: Project) {
        firebaseManager.update(collectionId, project.projectID.uuidString, project)
    }
    
    func `update`(project: Project, projectId: String) {
        firebaseManager.update(collectionId, projectId, project)
    }
    
}
