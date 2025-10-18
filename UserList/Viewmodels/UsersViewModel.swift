//
//  UsersViewModel.swift
//  UserList
//
//  Created by Suraj  Thomas on 18/10/25.
//

import Foundation

@MainActor
final class UsersViewModel: ObservableObject {
    @Published private(set) var users: [USerProfile] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let loader: UsersListAPiProtocol

    init(loader: UsersListAPiProtocol) {
        self.loader = loader
    }

    func load() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let items = try await loader.load()
            users = items
            errorMessage = nil
        } catch let error as UsersList.Error {
            switch error {
            case .connectivity: errorMessage = "Connectivity issue."
            case .invalidResponse: errorMessage = "Invalid server response."
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
