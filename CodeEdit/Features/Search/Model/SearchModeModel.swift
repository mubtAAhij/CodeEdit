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

    static let Containing = SearchModeModel(title: String(localized: "search.mode.containing", comment: "Search mode for containing text"), children: [], needSelectionHighlight: false)
    static let MatchingWord = SearchModeModel(
        title: String(localized: "search.mode.matching_word", comment: "Search mode for matching whole words"),
        children: [],
        needSelectionHighlight: true
    )
    static let StartingWith = SearchModeModel(
        title: String(localized: "search.mode.starting_with", comment: "Search mode for text starting with query"),
        children: [],
        needSelectionHighlight: true
    )
    static let EndingWith = SearchModeModel(title: String(localized: "search.mode.ending_with", comment: "Search mode for text ending with query"), children: [], needSelectionHighlight: true)

    static let Text = SearchModeModel(
        title: "Text",
        children: [.Containing, .MatchingWord, .StartingWith, .EndingWith],
        needSelectionHighlight: false
    )
    static let References = SearchModeModel(
        title: String(localized: "search.mode.references", comment: "Search mode for finding code references"),
        children: [.Containing, .MatchingWord, .StartingWith, .EndingWith],
        needSelectionHighlight: true
    )
    static let Definitions = SearchModeModel(
        title: String(localized: "search.mode.definitions", comment: "Search mode for finding code definitions"),
        children: [.Containing, .MatchingWord, .StartingWith, .EndingWith],
        needSelectionHighlight: true
    )
    static let RegularExpression = SearchModeModel(
        title: String(localized: "search.mode.regex", comment: "Search mode for regular expression matching"),
        children: [],
        needSelectionHighlight: true
    )
    static let CallHierarchy = SearchModeModel(
        title: String(localized: "search.mode.call_hierarchy", comment: "Search mode for call hierarchy analysis"),
        children: [],
        needSelectionHighlight: true
    )

    static let Find = SearchModeModel(
        title: String(localized: "search.mode.find", comment: "Main search mode for finding content"),
        children: [.Text, .References, .Definitions, .RegularExpression, .CallHierarchy],
        needSelectionHighlight: false
    )
    static let Replace = SearchModeModel(
        title: String(localized: "search.mode.replace", comment: "Main search mode for find and replace"),
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
