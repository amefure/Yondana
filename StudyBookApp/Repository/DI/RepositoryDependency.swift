//
//  RepositoryDependency.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/02.
//

import UIKit
/// `Repository` クラスのDIクラス
class RepositoryDependency {
    
    /// `Repository`
    public let realmRepository: RealmRepository
    public let userDefaultsRepository: UserDefaultsRepository
    public let googleBooksAPIRepository: GoogleBooksAPIRepository
    public let cameraFunctionRepository: CameraFunctionRepository
    
    //　シングルトンインスタンスをここで保持する
    private static let sharedRealmRepository = RealmRepository()
    private static let sharedUserDefaultsRepository = UserDefaultsRepository()
    private static let sharedGoogleBooksAPIRepository = GoogleBooksAPIRepository()
    private static let sharedCameraFunctionRepository = CameraFunctionRepository()

    init() {
        realmRepository = RepositoryDependency.sharedRealmRepository
        userDefaultsRepository = RepositoryDependency.sharedUserDefaultsRepository
        googleBooksAPIRepository = RepositoryDependency.sharedGoogleBooksAPIRepository
        cameraFunctionRepository = RepositoryDependency.sharedCameraFunctionRepository
    }
}

