//
//  InputCategoryViewModel.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/04.
//

import SwiftUI
import Combine

class InputCategoryViewModel: ObservableObject {
    
    private let realmRepository: RealmRepository
    
    private var cancellables = Set<AnyCancellable>()
    
    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        realmRepository = repositoryDependency.realmRepository
        
    }
    public func onAppear(isSaveBooks: [Book]) {
        
    }
    
    public func onDisappear() {
        cancellables.forEach { $0.cancel() }
    }
}

