//
//  AcknowledgementsModel.swift
//  CodeEditModules/Acknowledgements
//
//  Created by Lukas Pistrol on 01.05.22.
//

import SwiftUI

final class AcknowledgementsViewModel: ObservableObject {

    @Published private(set) var acknowledgements: [AcknowledgementDependency]

    var indexedAcknowledgements: [(index: Int, acknowledgement: AcknowledgementDependency)] {
      return Array(zip(acknowledgements.indices, acknowledgements))
    }

    init(_ dependencies: [AcknowledgementDependency] = []) {
        self.acknowledgements = dependencies

        if acknowledgements.isEmpty {
            fetchDependencies()
        }
    }

    func fetchDependencies() {
        self.acknowledgements.removeAll()
        do {
            if let bundlePath = Bundle.main.path(forResource: String(localized: "acknowledgements.package_column", defaultValue: "Package", comment: "Package.resolved file name"), ofType: String(localized: "acknowledgements.resolved_suffix", defaultValue: "resolved", comment: "Package.resolved file suffix")) {
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8)
                let parsedJSON = try JSONDecoder().decode(AcknowledgementObject.self, from: jsonData!)
                for dependency in parsedJSON.pins.sorted(by: { $0.identity < $1.identity })
                where dependency.identity.range(
                    of: String(localized: "acknowledgements.codeedit_regex", defaultValue: "[Cc]ode[Ee]dit", comment: "Regex pattern to match CodeEdit package name"),
                    options: .regularExpression,
                    range: nil,
                    locale: nil
                ) == nil {
                    self.acknowledgements.append(
                        AcknowledgementDependency(
                            name: dependency.name,
                            repositoryLink: dependency.location,
                            version: dependency.state.version ?? String(localized: "acknowledgements.separator", defaultValue: "-", comment: "Package name separator character")
                        )
                    )
                }
            }
        } catch {
            print(error)
        }
    }
}
