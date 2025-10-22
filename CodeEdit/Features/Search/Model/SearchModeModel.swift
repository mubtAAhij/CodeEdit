//
//  SearchModeModel.swift
//  CodeEditModules/Search
//
//  Created by Ziyuan Zhao on 2022/3/22.
//

import Foundation

// TODO: DOCS (Ziyuan Zhao)
struct SearchModeModel: Hashable {
    let title: String
    let children: [SearchModeModel]
    let needSelectionHighlight: Bool

    static let Containing = SearchModeModel(title: String(localized: "Containing", comment: "Search mode label"), children: [], needSelectionHighlight: false)
    static let MatchingWord = SearchModeModel(
        title: String(localized: "Matching Word", comment: "Search mode label"),
        children: [],
        needSelectionHighlight: true
    )
    static let StartingWith = SearchModeModel(
        title: String(localized: "Starting With", comment: "Search mode label"),
        children: [],
        needSelectionHighlight: true
    )
    static let EndingWith = SearchModeModel(title: String(localized: "Ending With", comment: "Search mode label"), children: [], needSelectionHighlight: true)

    static let Text = SearchModeModel(
        title: "Text",
        children: [.Containing, .MatchingWord, .StartingWith, .EndingWith],
        needSelectionHighlight: false
    )
    static let References = SearchModeModel(
        title: String(localized: "References", comment: "Search mode label"),
        children: [.Containing, .MatchingWord, .StartingWith, .EndingWith],
        needSelectionHighlight: true
    )
    static let Definitions = SearchModeModel(
        title: String(localized: "Definitions", comment: "Search mode label"),
        children: [.Containing, .MatchingWord, .StartingWith, .EndingWith],
        needSelectionHighlight: true
    )
    static let RegularExpression = SearchModeModel(
        title: String(localized: "Regular Expression", comment: "Search mode label"),
        children: [],
        needSelectionHighlight: true
    )
    static let CallHierarchy = SearchModeModel(
        title: String(localized: "Call Hierarchy", comment: "Search mode label"),
        children: [],
        needSelectionHighlight: true
    )

    static let Find = SearchModeModel(
        title: String(localized: "Find", comment: "Search mode label"),
        children: [.Text, .References, .Definitions, .RegularExpression, .CallHierarchy],
        needSelectionHighlight: false
    )
    static let Replace = SearchModeModel(
        title: String(localized: "Replace", comment: "Search mode label"),
        children: [.Text, .RegularExpression],
        needSelectionHighlight: true
    )

    static let TextMatchingModes: [SearchModeModel] = [.Containing, .MatchingWord, .StartingWith, .EndingWith]
    static let FindModes: [SearchModeModel] = [
        .Text,
        .References,
        .Definitions,
        .RegularExpression,
        .CallHierarchy
    ]
    static let ReplaceModes: [SearchModeModel] = [.Text, .RegularExpression]
    static let SearchModes: [SearchModeModel] = [.Find, .Replace]
}

extension SearchModeModel: Equatable {
    static func == (lhs: SearchModeModel, rhs: SearchModeModel) -> Bool {
        lhs.title == rhs.title
            && lhs.children == rhs.children
            && lhs.needSelectionHighlight == rhs.needSelectionHighlight
    }
}
