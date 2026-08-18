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

    static let Containing = SearchModeModel(title: String(
        localized: "search.mode.containing",
        defaultValue: "Containing",
        comment: "Search mode label for matching text containing the query."
    ), children: [], needSelectionHighlight: false)
    static let MatchingWord = SearchModeModel(
        title: String(
            localized: "search.mode.matching-word",
            defaultValue: "Matching Word",
            comment: "Search mode label for matching whole words."
        ),
        children: [],
        needSelectionHighlight: true
    )
    static let StartingWith = SearchModeModel(
        title: String(
            localized: "search.mode.starting-with",
            defaultValue: "Starting With",
            comment: "Search mode label for matching text starting with query."
        ),
        children: [],
        needSelectionHighlight: true
    )
    static let EndingWith = SearchModeModel(title: String(
        localized: "search.mode.ending-with",
        defaultValue: "Ending With",
        comment: "Search mode label for matching text ending with query."
    ), children: [], needSelectionHighlight: true)

    static let Text = SearchModeModel(
        title: String(
            localized: "search.scope.text",
            defaultValue: "Text",
            comment: "Search scope label for text search."
        ),
        children: [.Containing, .MatchingWord, .StartingWith, .EndingWith],
        needSelectionHighlight: false
    )
    static let References = SearchModeModel(
        title: String(
            localized: "search.scope.references",
            defaultValue: "References",
            comment: "Search scope label for symbol references."
        ),
        children: [.Containing, .MatchingWord, .StartingWith, .EndingWith],
        needSelectionHighlight: true
    )
    static let Definitions = SearchModeModel(
        title: String(
            localized: "search.scope.definitions",
            defaultValue: "Definitions",
            comment: "Search scope label for symbol definitions."
        ),
        children: [.Containing, .MatchingWord, .StartingWith, .EndingWith],
        needSelectionHighlight: true
    )
    static let RegularExpression = SearchModeModel(
        title: String(
            localized: "search.mode.regular-expression",
            defaultValue: "Regular Expression",
            comment: "Search mode label for regular expression search."
        ),
        children: [],
        needSelectionHighlight: true
    )
    static let CallHierarchy = SearchModeModel(
        title: String(
            localized: "search.scope.call-hierarchy",
            defaultValue: "Call Hierarchy",
            comment: "Search scope label for call hierarchy."
        ),
        children: [],
        needSelectionHighlight: true
    )

    static let Find = SearchModeModel(
        title: String(localized: "search.action.find", defaultValue: "Find", comment: "Action label for find mode."),
        children: [.Text, .References, .Definitions, .RegularExpression, .CallHierarchy],
        needSelectionHighlight: false
    )
    static let Replace = SearchModeModel(
        title: String(
            localized: "search.action.replace",
            defaultValue: "Replace",
            comment: "Action label for replace mode."
        ),
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
