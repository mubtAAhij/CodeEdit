//
//  SearchModeModel.swift
//  CodeEditModules/Search
//
//  Created by Ziyuan Zhao on 2022/3/22.
//

import Foundation

// TODO: DOCS (Ziyuan Zhao)
struct SearchModeModel: Hashable {
    let id: String
    let title: String
    let children: [SearchModeModel]
    let needSelectionHighlight: Bool

    static let Containing = SearchModeModel(id: "containing", title: String(localized: "search-mode.containing", defaultValue: "Containing", comment: "Search mode for text containing search term"), children: [], needSelectionHighlight: false)
    static let MatchingWord = SearchModeModel(
        id: "matchingWord",
        title: String(localized: "search-mode.matching-word", defaultValue: "Matching Word", comment: "Search mode for matching whole words"),
        children: [],
        needSelectionHighlight: true
    )
    static let StartingWith = SearchModeModel(
        id: "startingWith",
        title: String(localized: "search-mode.starting-with", defaultValue: "Starting With", comment: "Search mode for text starting with search term"),
        children: [],
        needSelectionHighlight: true
    )
    static let EndingWith = SearchModeModel(id: "endingWith", title: String(localized: "search-mode.ending-with", defaultValue: "Ending With", comment: "Search mode for text ending with search term"), children: [], needSelectionHighlight: true)

    static let Text = SearchModeModel(
        id: "text",
        title: String(localized: "search-mode.text", defaultValue: "Text", comment: "Search mode for text search"),
        children: [.Containing, .MatchingWord, .StartingWith, .EndingWith],
        needSelectionHighlight: false
    )
    static let References = SearchModeModel(
        id: "references",
        title: String(localized: "search-mode.references", defaultValue: "References", comment: "Search mode for finding references"),
        children: [.Containing, .MatchingWord, .StartingWith, .EndingWith],
        needSelectionHighlight: true
    )
    static let Definitions = SearchModeModel(
        id: "definitions",
        title: String(localized: "search-mode.definitions", defaultValue: "Definitions", comment: "Search mode for finding definitions"),
        children: [.Containing, .MatchingWord, .StartingWith, .EndingWith],
        needSelectionHighlight: true
    )
    static let RegularExpression = SearchModeModel(
        id: "regularExpression",
        title: String(localized: "search-mode.regular-expression", defaultValue: "Regular Expression", comment: "Search mode for regular expression search"),
        children: [],
        needSelectionHighlight: true
    )
    static let CallHierarchy = SearchModeModel(
        id: "callHierarchy",
        title: String(localized: "search-mode.call-hierarchy", defaultValue: "Call Hierarchy", comment: "Search mode for call hierarchy"),
        children: [],
        needSelectionHighlight: true
    )

    static let Find = SearchModeModel(
        id: "find",
        title: String(localized: "search-mode.find", defaultValue: "Find", comment: "Main search mode for finding"),
        children: [.Text, .References, .Definitions, .RegularExpression, .CallHierarchy],
        needSelectionHighlight: false
    )
    static let Replace = SearchModeModel(
        id: "replace",
        title: String(localized: "search-mode.replace", defaultValue: "Replace", comment: "Main search mode for replacing"),
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
        lhs.id == rhs.id
            && lhs.children == rhs.children
            && lhs.needSelectionHighlight == rhs.needSelectionHighlight
    }
}
