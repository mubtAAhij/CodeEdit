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

    static let Containing = SearchModeModel(title: String(localized: "search_mode.containing", defaultValue: "Containing", comment: "Search mode option label for matching text that contains query"), children: [], needSelectionHighlight: false)
    static let MatchingWord = SearchModeModel(
        title: String(localized: "search_mode.matching_word", defaultValue: "Matching Word", comment: "Search mode option label for matching whole words"),
        children: [],
        needSelectionHighlight: true
    )
    static let StartingWith = SearchModeModel(
        title: String(localized: "search_mode.starting_with", defaultValue: "Starting With", comment: "Search mode option label for matching text that starts with query"),
        children: [],
        needSelectionHighlight: true
    )
    static let EndingWith = SearchModeModel(title: String(localized: "search_mode.ending_with", defaultValue: "Ending With", comment: "Search mode option label for matching text that ends with query"), children: [], needSelectionHighlight: true)

    static let Text = SearchModeModel(
        title: String(localized: "search_mode.text", defaultValue: "Text", comment: "Search mode category label for plain text search"),
        children: [.Containing, .MatchingWord, .StartingWith, .EndingWith],
        needSelectionHighlight: false
    )
    static let References = SearchModeModel(
        title: String(localized: "search_mode.references", defaultValue: "References", comment: "Search mode option label for finding symbol references"),
        children: [.Containing, .MatchingWord, .StartingWith, .EndingWith],
        needSelectionHighlight: true
    )
    static let Definitions = SearchModeModel(
        title: String(localized: "search_mode.definitions", defaultValue: "Definitions", comment: "Search mode option label for finding symbol definitions"),
        children: [.Containing, .MatchingWord, .StartingWith, .EndingWith],
        needSelectionHighlight: true
    )
    static let RegularExpression = SearchModeModel(
        title: String(localized: "search_mode.regular_expression", defaultValue: "Regular Expression", comment: "Search mode option label for regular expression search"),
        children: [],
        needSelectionHighlight: true
    )
    static let CallHierarchy = SearchModeModel(
        title: String(localized: "search_mode.call_hierarchy", defaultValue: "Call Hierarchy", comment: "Search mode option label for call hierarchy search"),
        children: [],
        needSelectionHighlight: true
    )

    static let Find = SearchModeModel(
        title: String(localized: "search_mode.find", defaultValue: "Find", comment: "Search mode group label for find functionality"),
        children: [.Text, .References, .Definitions, .RegularExpression, .CallHierarchy],
        needSelectionHighlight: false
    )
    static let Replace = SearchModeModel(
        title: String(localized: "search_mode.replace", defaultValue: "Replace", comment: "Search mode option label for replace mode"),
        children: [.Text, .RegularExpression],
        needSelectionHighlight: true
    )

    static let TextMatchingModes: [SearchModeModel] = [.Containing, .MatchingWord, .StartingWith, .EndingWith]
    static let FindModes: [SearchModeModel] = [
        .Text,
        .References,
        .Definitions,
        .RegularExpression,
        .CallHierarchy,
    ]
    static let ReplaceModes: [SearchModeModel] = [.Text, .RegularExpression]
    static let SearchModes: [SearchModeModel] = [.Find, .Replace]
}

extension SearchModeModel: Equatable {}
