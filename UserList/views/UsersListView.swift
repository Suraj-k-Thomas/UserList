//
//  UsersListView.swift
//  UserList
//
//  Created by Suraj  Thomas on 18/10/25.
//

import SwiftUI

struct UsersListView: View {
    @StateObject private var viewModel: UsersViewModel

    init(viewModel: UsersViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.users.isEmpty {
                    ProgressView("Loading users…")
                } else if let error = viewModel.errorMessage, viewModel.users.isEmpty {
                    VStack(spacing: 12) {
                        Text(error).foregroundStyle(.red)
                        Button("Retry") { Task { await viewModel.load() } }
                    }
                } else {
                    List(viewModel.users) { user in
                        NavigationLink(value: user) {
                            HStack(spacing: 12) {
                                AsyncImage(url: URL(string: user.photo)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView().frame(width: 44, height: 44)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 44, height: 44)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    case .failure:
                                        Image(systemName: "person.crop.square")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 44, height: 44)
                                            .foregroundStyle(.secondary)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(user.name).font(.headline)
                                    Text(user.company).font(.subheadline).foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .refreshable { await viewModel.load() }
                }
            }
            .navigationTitle("Users")
            .navigationDestination(for: USerProfile.self) { user in
                UserDetailView(viewModel: .init(user: user))
            }
        }
        .task {
            if viewModel.users.isEmpty { await viewModel.load() }
        }
    }
}

//#Preview {
//    UsersListView()
//}
