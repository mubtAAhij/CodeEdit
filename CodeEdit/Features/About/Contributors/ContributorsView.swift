//
//  ContributorsView.swift
//  CodeEdit
//
//  Created by Lukas Pistrol on 19.01.23.
//

import AboutWindow
import SwiftUI

struct ContributorsView: View {
    @StateObject var model = ContributorsViewModel()

    var body: some View {
        AboutDetailView(title: String(localized: "about.contributors.title", defaultValue: "Contributors", comment: "Title for the contributors section in the About window")) {
            LazyVStack(spacing: 0) {
                ForEach(model.contributors) { contributor in
                    ContributorRowView(contributor: contributor)
                    Divider()
                        .frame(height: 0.5)
                        .opacity(0.5)
                }
            }
        }
    }
}

class ContributorsViewModel: ObservableObject {
    @Published private(set) var contributors: [Contributor] = []

    init() {
        guard let url = Bundle.main.url(
            forResource: ".all-contributorsrc",
            withExtension: nil
        ) else { return }
        do {
            let data = try Data(contentsOf: url)
            let root = try JSONDecoder().decode(ContributorsRoot.self, from: data)
            contributors = root.contributors
        } catch {
            print(error)
        }
    }
}
