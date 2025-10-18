//
//  UserDetailViewModel.swift
//  UserList
//
//  Created by Suraj  Thomas on 18/10/25.
//

import Foundation

@MainActor
final class UserDetailViewModel: ObservableObject {
    @Published private(set) var user: USerProfile

    init(user: USerProfile) {
        self.user = user
    }
}
