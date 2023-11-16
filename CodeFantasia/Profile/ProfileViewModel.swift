//
//  ProfileViewModel.swift
//  CodeFantasia
//
//  Created by Hyunwoo Lee on 2023/10/24.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxCocoa
import UIKit
import Firebase

final class ProfileViewModel {
    struct Input {
        var viewDidLoad: Observable<Void>
        var profileEditTapped: Driver<Void>
        var logoutTapped: Driver<Void>
        var withdrawTapped: Driver<Void>
        var followStatusTapped: Driver<Void>
        var followingsTapped: Driver<Void>
        var followersTapped: Driver<Void>
    }
    struct Output {
        var userDataFetched: Observable<UserProfile>
        var userAuthConfirmed: Driver<Bool>
        var profileEditDidTap: Driver<Void>
        var logoutDidTap: Driver<Void>
        var withdrawDidTap: Driver<String?>
        var followStatusDidTap: Driver<Void>
        var followingsDidTap: Driver<Void>
        var followersDidTap: Driver<Void>
    }
    let editMove = PublishSubject<Void>()
    let logoutComplete = PublishSubject<Void>()
    let deleteComplete = PublishSubject<Void>()
    let followComplete = PublishSubject<Void>()
    let unfollowComplete = PublishSubject<Void>()
    let dataUpdateTrigger = PublishSubject<UserProfile>()
    let isFollowing = BehaviorRelay<Bool>(value: false)
    private let USER_REF = Firestore.firestore().collection("User")
    private let PROJ_REF = Firestore.firestore().collection("Project")
    private let currentUser = Auth.auth().currentUser?.uid
    private let disposeBag = DisposeBag()
    private let userRepository: UserRepositoryProtocol
    private let userId: String
    var userProfile: UserProfile?
    
    init(
        userRepository: UserRepositoryProtocol,
        userId: String
    ) {
        self.userRepository = userRepository
        self.userId = userId
    }
    
    private func updateIsFollowing(_ user: UserProfile) {
        USER_REF.document(currentUser ?? "").getDocument { [weak self] document, error in
            guard let self = self else { return }
            
            if let document = document, document.exists {
                if let followingArray = document.data()?["following"] as? [String],
                   let userProfileID = user.userID {
                    let isFollowing = followingArray.contains(userProfileID)
                    self.isFollowing.accept(isFollowing)
                } else {
                    self.isFollowing.accept(false)
                }
            } else {
                self.isFollowing.accept(false)
            }
        }
    }
    
    func transform(input: Input) -> Output {
        
        let userData = input.viewDidLoad
            .startWith(())
            .flatMapLatest { [weak self] _ -> Observable<UserProfile> in
                guard let self = self else {
                    return .empty()
                }
                print("유저 데이터 가져오는 중...")
                return self.userRepository.read(userId: self.userId)
                    .asObservable() // Single을 Observable로 변환
                    .do(onNext: { [weak self] user in
                        print("유저 데이터 받음: \(user)")
                        self?.updateIsFollowing(user)
                    })
            }
            .share()
        
        userData
            .subscribe(onNext: { [weak self] user in
                self?.userProfile = user
                print("User data updated: \(user)")
            }, onError: { error in
                // 에러 처리 로직을 수행합니다.
            })
            .disposed(by: disposeBag)
        
        followComplete.subscribe { [weak self] _ in
            self?.USER_REF.document(self?.currentUser ?? "").getDocument { (document, error) in
                if let document = document, document.exists {
                    if var following = document.data()?["following"] as? [String] {
                        if !following.contains(self?.userProfile?.userID ?? "") {
                            following.append(self?.userProfile?.userID ?? "")
                            self?.USER_REF.document(self?.currentUser ?? "").setData(["following": following], merge: true) { error in
                                if let error = error {
                                    print("데이터를 업데이트하는 동안 오류가 발생했습니다: \(error)")
                                } else {
                                    print("내 팔로우 데이터가 업데이트되었습니다.")
                                }
                            }
                        } else {
                        }
                    } else {
                        // blockIDs 필드가 없는 경우, 새로운 배열을 만들어서 selfWriterID를 추가합니다.
                        self?.USER_REF.document(self?.currentUser ?? "").setData(["following": [self?.userProfile?.userID]], merge: true) { error in
                            if let error = error {
                                print("데이터를 설정하는 동안 오류가 발생했습니다: \(error)")
                            } else {
                                print("내 팔로우 데이터가 추가 되었습니다")
                            }
                        }
                    }
                } else {
                    print("문서를 찾을 수 없습니다.")
                }
            }
            self?.USER_REF.document(self?.userProfile?.userID ?? "").getDocument { (document, error) in
                if let document = document, document.exists {
                    if var followers = document.data()?["followers"] as? [String] {
                        if !followers.contains(self?.currentUser ?? "") {
                            followers.append(self?.currentUser ?? "")
                            self?.USER_REF.document(self?.userProfile?.userID ?? "").setData(["followers": followers], merge: true) { error in
                                if let error = error {
                                    print("데이터를 업데이트하는 동안 오류가 발생했습니다: \(error)")
                                } else {
                                    print("상대의 팔로워 데이터가 업데이트 되었습니다.")
                                }
                            }
                        } else {
                        }
                    } else {
                        self?.USER_REF.document(self?.userProfile?.userID ?? "").setData(["followers": [self?.currentUser ?? ""]], merge: true) { error in
                            if let error = error {
                                print("데이터를 설정하는 동안 오류가 발생했습니다: \(error)")
                            } else {
                                print("상대의 팔로워 데이터가 설정 되었습니다.")
                            }
                        }
                    }
                } else {
                    print("문서를 찾을 수 없습니다.")
                }
            }
            self?.isFollowing.accept(true)
        }
        .disposed(by: disposeBag)
        
        unfollowComplete.subscribe { [weak self] _ in
            self?.USER_REF.document(self?.currentUser ?? "").getDocument { (document, error) in
                if let document = document, document.exists {
                    if var following = document.data()?["following"] as? [String] {
                        if let userProfileID = self?.userProfile?.userID, let index = following.firstIndex(of: userProfileID) {
                            following.remove(at: index)
                        }
                        self?.USER_REF.document(self?.currentUser ?? "").setData(["following": following], merge: true) { error in
                            if let error = error {
                                print("데이터를 업데이트하는 동안 오류가 발생했습니다: \(error)")
                            } else {
                                print("팔로잉이 취소 되었습니다.")
                            }
                        }
                    } else {
                    }
                } else {
                    print("문서를 찾을 수 없습니다.")
                }
            }
            
            self?.USER_REF.document(self?.userProfile?.userID ?? "").getDocument { (document, error) in
                if let document = document, document.exists {
                    if var followers = document.data()?["followers"] as? [String] {
                        if let userProfileID = self?.currentUser, let index = followers.firstIndex(of: userProfileID) {
                            followers.remove(at: index)
                        }
                        self?.USER_REF.document(self?.userProfile?.userID ?? "").setData(["followers": followers], merge: true) { error in
                            if let error = error {
                                print("데이터를 업데이트하는 동안 오류가 발생했습니다: \(error)")
                            } else {
                                print("팔로워가 취소 되었습니다.")
                            }
                        }
                    } else {
                    }
                } else {
                    print("문서를 찾을 수 없습니다.")
                }
            }
            self?.isFollowing.accept(false)
        }
        .disposed(by: disposeBag)
        
        deleteComplete.subscribe { [weak self] _ in
            guard let self = self else { return }
            if let current = userProfile?.userID {
                self.userRepository.delete(userId: current)
                print("유저 프로필 삭제 완료")
                let followersQuery = USER_REF.whereField("followers", arrayContains: current)
                followersQuery.getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        for document in querySnapshot!.documents {
                            document.reference.updateData(["followers": FieldValue.arrayRemove([current])])
                            print("유저 팔로워 삭제 완료")
                        }
                    }
                }
                
                let followingQuery = USER_REF.whereField("followers", arrayContains: current)
                followingQuery.getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        for document in querySnapshot!.documents {
                            document.reference.updateData(["followers": FieldValue.arrayRemove([current])])
                            print("유저 팔로잉 삭제 완료")
                        }
                    }
                }
             
                PROJ_REF.whereField("writerID", isEqualTo: current ).getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        for document in querySnapshot!.documents {
                            document.reference.delete()
                            print("유저 게시글 삭제 완료")
                        }
                    }
                }
            }
        }
        .disposed(by: disposeBag)
        
        logoutComplete.subscribe { [weak self] _ in
            guard let self = self else { return }
            do {
                try Auth.auth().signOut()
                DispatchQueue.main.async {
                    guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                        fatalError("could not get scene delegate ")
                    }
                    sceneDelegate.window?.rootViewController = TabBarController()
                }
            } catch let signOutError as NSError {
                print("Error signing out: \(signOutError)")
            }
        }
        .disposed(by: disposeBag)
        
        return Output(
            userDataFetched: userData,
            userAuthConfirmed: userData.map { [weak self] user in
                guard let currentAuthor = Auth.auth().currentUser?.uid else {
                    return false
                }
                return user.userID == currentAuthor
            }.asDriver(onErrorJustReturn: false),
            profileEditDidTap: input.profileEditTapped,
            logoutDidTap: input.logoutTapped,
            withdrawDidTap: input.withdrawTapped.map { [weak self] _ in
                self?.userProfile?.userID
            },
            followStatusDidTap: input.followStatusTapped,
            followingsDidTap: input.followingsTapped,
            followersDidTap: input.followersTapped
        )
    }
}


