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

    static let Containing = SearchModeModel(title: "Containing", children: [], needSelectionHighlight: false)
    static let MatchingWord = SearchModeModel(
        title: "String(localized: "matching_word", comment: "Search mode: matching word")",
        children: [],
        needSelectionHighlight: true
    )
    static let StartingWith = SearchModeModel(
        title: "String(localized: "starting_with", comment: "Search mode: starting with")",
        children: [],
        needSelectionHighlight: true
    )
    static let EndingWith = SearchModeModel(title: "String(localized: "ending_with", comment: "Search mode: ending with")", children: [], needSelectionHighlight: true)

    static let Text = SearchModeModel(
        title: "Text",
        children: [.Containing, .MatchingWord, .StartingWith, .EndingWith],
        needSelectionHighlight: false
    )
    static let References = SearchModeModel(
        title: "String(localized: "references", comment: "Search mode: references")",
        children: [.Containing, .MatchingWord, .StartingWith, .EndingWith],
        needSelectionHighlight: true
    )
    static let Definitions = SearchModeModel(
        title: "String(localized: "definitions", comment: "Search mode: definitions")",
        children: [.Containing, .MatchingWord, .StartingWith, .EndingWith],
        needSelectionHighlight: true
    )
    static let RegularExpression = SearchModeModel(
        title: "String(localized: "regular_expression", comment: "Search mode: regular expression")",
        children: [],
        needSelectionHighlight: true
    )
    static let CallHierarchy = SearchModeModel(
        title: "String(localized: "call_hierarchy", comment: "Search mode: call hierarchy")",
        children: [],
        needSelectionHighlight: true
    )

    static let Find = SearchModeModel(
        title: "String(localized: "find", comment: "Find action label")",
        children: [.Text, .References, .Definitions, .RegularExpression, .CallHierarchy],
        needSelectionHighlight: false
    )
    static let Replace = SearchModeModel(
        title: "String(localized: "replace", comment: "Replace action label")",
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
