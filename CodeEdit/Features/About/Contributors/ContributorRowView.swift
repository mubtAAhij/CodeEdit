//
//  ContributorRowView.swift
//  CodeEdit
//
//  Created by Lukas Pistrol on 19.01.23.
//

import SwiftUI
import CodeEditSymbols

struct ContributorRowView: View {

    let contributor: Contributor

    var body: some View {
        HStack {
            userImage
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(contributor.name)
                        .font(.headline)
                }
                HStack(spacing: 3) {
                    ForEach(contributor.contributions, id: \.self) { item in
                        tag(item)
                    }
                }
            }
            Spacer()
            HStack(alignment: .top) {
                if let profileURL = contributor.profileURL, profileURL != contributor.gitHubURL {
                    ActionButton(url: profileURL, image: .init(systemName: String(localized: "contributors.profile_icon", defaultValue: "globe", comment: "Profile icon")))
                }
                if let gitHubURL = contributor.gitHubURL {
                    ActionButton(url: gitHubURL, image: .github)
                }
            }
        }
        .padding(.vertical, 8)
    }

    private var userImage: some View {
        AsyncImage(url: contributor.avatarURL) { image in
            image
                .resizable()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                .help(contributor.name)
        } placeholder: {
            Image(systemName: String(localized: "contributors.avatar_placeholder", defaultValue: "person.circle.fill", comment: "Avatar placeholder icon"))
                .resizable()
                .frame(width: 32, height: 32)
                .help(contributor.name)
        }
    }

    private func tag(_ item: Contributor.Contribution) -> some View {
        Text(item.rawValue.capitalized)
            .font(.caption)
            .padding(.horizontal, 6)
            .padding(.vertical, 1)
            .foregroundColor(item.color)
            .background {
                Capsule(style: .continuous)
                    .strokeBorder(lineWidth: 1)
                    .foregroundStyle(item.color)
                    .opacity(0.8)
            }
    }

    private struct ActionButton: View {
        @Environment(\.openURL)
        private var openURL
        @State private var hovering = false

        let url: URL
        let image: Image

        var body: some View {
            Button {
                openURL(url)
            } label: {
                image
                    .imageScale(.medium)
                    .foregroundColor(hovering ? .primary : .secondary)
            }
            .buttonStyle(.plain)
            .onHover { hover in
                hovering = hover
            }
        }
    }
}

struct ContributorRowView_Previews: PreviewProvider {
    static var previews: some View {
        let contributor = Contributor(
            login: String(localized: "contributors.preview.login", defaultValue: "lukepistrol", comment: "Preview contributor login"),
            name: String(localized: "contributors.preview.name", defaultValue: "Lukas Pistrol", comment: "Preview contributor name"),
            avatarURLString: String(localized: "contributors.preview.avatar_url", defaultValue: "https://avatars.githubusercontent.com/u/9460130?v=4", comment: "Preview avatar URL"),
            profile: String(localized: "contributors.preview.profile_url", defaultValue: "http://lukaspistrol.com", comment: "Preview profile URL"),
            contributions: [.infra, .test, .code]
        )
        ContributorRowView(contributor: contributor)
            .frame(width: 350)
    }
}
