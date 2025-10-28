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

    static let Containing = SearchModeModel(title: String(localized: "search.mode.containing", comment: "Search mode option"), children: [], needSelectionHighlight: false)
    static let MatchingWord = SearchModeModel(
        title: String(localized: "search.mode.matching_word", comment: "Search mode option"),
        children: [],
        needSelectionHighlight: true
    )
    static let StartingWith = SearchModeModel(
        title: String(localized: "search.mode.starting_with", comment: "Search mode option"),
        children: [],
        needSelectionHighlight: true
    )
    static let EndingWith = SearchModeModel(title: String(localized: "search.mode.ending_with", comment: "Search mode option"), children: [], needSelectionHighlight: true)

    static let Text = SearchModeModel(
        title: "Text",
        children: [.Containing, .MatchingWord, .StartingWith, .EndingWith],
        needSelectionHighlight: false
    )
    static let References = SearchModeModel(
        title: String(localized: "search.mode.references", comment: "Search mode option"),
        children: [.Containing, .MatchingWord, .StartingWith, .EndingWith],
        needSelectionHighlight: true
    )
    static let Definitions = SearchModeModel(
        title: String(localized: "search.mode.definitions", comment: "Search mode option"),
        children: [.Containing, .MatchingWord, .StartingWith, .EndingWith],
        needSelectionHighlight: true
    )
    static let RegularExpression = SearchModeModel(
        title: String(localized: "search.mode.regular_expression", comment: "Search mode option"),
        children: [],
        needSelectionHighlight: true
    )
    static let CallHierarchy = SearchModeModel(
        title: String(localized: "search.mode.call_hierarchy", comment: "Search mode option"),
        children: [],
        needSelectionHighlight: true
    )

    static let Find = SearchModeModel(
        title: String(localized: "search.mode.find", comment: "Search mode option"),
        children: [.Text, .References, .Definitions, .RegularExpression, .CallHierarchy],
        needSelectionHighlight: false
    )
    static let Replace = SearchModeModel(
        title: String(localized: "search.mode.replace", comment: "Search mode option"),
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
