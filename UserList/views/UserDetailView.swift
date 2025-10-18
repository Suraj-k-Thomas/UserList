//
//  UserDetailView.swift
//  UserList
//
//  Created by Suraj  Thomas on 18/10/25.
//

import SwiftUI

struct UserDetailView: View {
    @StateObject private var viewModel: UserDetailViewModel

    init(viewModel: UserDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        List {
            Section {
                HStack(alignment: .top, spacing: 12) {
                    AsyncImage(url: URL(string: viewModel.user.photo)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView().frame(width: 72, height: 72)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 72, height: 72)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        case .failure:
                            Image(systemName: "person.crop.square")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 72, height: 72)
                                .foregroundStyle(.secondary)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        Text(viewModel.user.name).font(.title3).bold()
                        Text(viewModel.user.company).foregroundStyle(.secondary)
                        
                        LabeledContent("Username", value: viewModel.user.username)
                        LabeledContent("Email", value: viewModel.user.email)
                        LabeledContent("Phone", value: viewModel.user.phone)
                        
                        LabeledContent("Address", value: viewModel.user.address)
                        LabeledContent("Zip", value: viewModel.user.zip)
                        LabeledContent("State", value: viewModel.user.state)
                        LabeledContent("Country", value: viewModel.user.country)
                        
                        LabeledContent("ID", value: String(viewModel.user.id))
                        LabeledContent("Photo URL", value: viewModel.user.photo)
                        
                    }
                }
            }
        }
        .navigationTitle("Details")
    }
}


#Preview {
    let sample = USerProfile(
        id: 1,
        name: "Suraj Thomas",
        company: "some company",
        username: "suraj.user",
        email: "suraj@suraj.com",
        address: "b305 max spoorthy",
        zip: "560097",
        state: "KArnataka",
        country: "India",
        phone: "+918748447447",
        photo: "https://picsum.photos/20"
    )

    let vm = UserDetailViewModel(user: sample)

    return NavigationStack {
        UserDetailView(viewModel: vm)
    }
}
