//
//  SearchModeSelector.swift
//  CodeEdit
//
//  Created by Ziyuan Zhao on 2022/3/21.
//

import SwiftUI

struct FindNavigatorForm: View {
    @ObservedObject private var state: WorkspaceDocument.SearchState

    @State private var selectedMode: [SearchModeModel] {
        didSet {
            // sync the variables, as selectedMode is an array
            // and cannot be synced directly with @ObservedObject
            state.selectedMode = selectedMode
        }
    }

    @State private var includesText: String = ""
    @State private var excludesText: String = ""
    @State private var scoped: Bool = false
    @State private var caseSensitive: Bool = false
    @State private var preserveCase: Bool = false
    @State private var scopedToOpenEditors: Bool = false
    @State private var excludeSettings: Bool = true
    @FocusState private var isSearchFieldFocused: Bool

    init(state: WorkspaceDocument.SearchState) {
        self.state = state
        selectedMode = state.selectedMode
    }

    private var chevron: some View {
        Image(systemName: String(localized: "find.navigator.chevron.icon", defaultValue: "chevron.compact.right", comment: "System icon name for chevron separator in find navigator"))
            .foregroundStyle(.tertiary)
            .imageScale(.large)
    }

    var body: some View {
        VStack {
            HStack {
                HStack(spacing: 0) {
                    ForEach(0..<selectedMode.count, id: \.self) { index in
                        FindModePicker(
                            modes: getMenuList(index),
                            selection: Binding(
                                get: {
                                    selectedMode[index]
                                },
                                set: { searchMode in
                                    onSelectMenuItem(index, searchMode: searchMode)
                                }
                            ),
                            onSelect: { searchMode in
                                onSelectMenuItem(index, searchMode: searchMode)
                            },
                            isLastItem: index == selectedMode.count-1
                        )
                    }
                    Spacer()
                }
                Spacer()
                Text(String(localized: "find.navigator.scoped.label", defaultValue: "Scoped", comment: "Label for scoped search toggle in find navigator"))
                    .controlSize(.small)
                    .foregroundStyle(Color(nsColor: scoped ? .controlAccentColor : .controlTextColor))
                    .onTapGesture {
                        scoped.toggle()
                    }
            }
            .padding(.top, -5)
            .padding(.bottom, -8)
            PaneTextField(
                state.selectedMode[1].title,
                text: $state.searchQuery,
                axis: .vertical,
                leadingAccessories: {
                    Image(systemName: String(localized: "find.navigator.search.icon", defaultValue: "magnifyingglass", comment: "System icon name for search field in find navigator"))
                        .padding(.leading, 8)
                        .foregroundStyle(.tertiary)
                        .font(.system(size: 12))
                        .frame(width: 16, height: 20)
                },
                trailingAccessories: {
                    Divider()
                    Toggle(
                        isOn: $caseSensitive,
                        label: {
                        Image(systemName: String(localized: "find.navigator.match.case.icon", defaultValue: "textformat", comment: "System icon name for match case toggle in find navigator"))
                            .foregroundStyle(caseSensitive ? Color(.controlAccentColor) : Color(.secondaryLabelColor))
                        }
                    )
                    .help(String(localized: "find.navigator.match.case.help", defaultValue: "Match Case", comment: "Help text for match case toggle in find navigator"))
                    .onChange(of: caseSensitive) { _, newValue in
                        state.caseSensitive = newValue
                    }
                },
                clearable: true,
                onClear: {
                    state.clearResults()
                },
                hasValue: caseSensitive
            )
            .focused($isSearchFieldFocused)
            .onSubmit {
                if !state.searchQuery.isEmpty {
                    Task {
                        await state.search(state.searchQuery)
                    }
                } else {
                    // If a user performs a search with an empty string, the search results will be cleared.
                    // This behavior aligns with Xcode's handling of empty search queries.
                    state.clearResults()
                }
            }
            if selectedMode[0] == SearchModeModel.Replace {
                PaneTextField(
                    String(localized: "find.navigator.replace.placeholder", defaultValue: "With", comment: "Placeholder text for replace field in find navigator"),
                    text: $state.replaceText,
                    axis: .vertical,
                    leadingAccessories: {
                        Image(systemName: String(localized: "find.navigator.replace.icon", defaultValue: "arrow.2.squarepath", comment: "System icon name for replace field in find navigator"))
                            .padding(.leading, 8)
                            .foregroundStyle(.tertiary)
                            .font(.system(size: 12))
                            .frame(width: 16, height: 20)
                    },
                    trailingAccessories: {
                        Divider()
                        Toggle(
                            isOn: $preserveCase,
                            label: {
                                Text(String(localized: "find.navigator.preserve.case.label", defaultValue: "AB", comment: "Label text for preserve case toggle in find navigator"))
                                    .font(.system(size: 12, design: .rounded))
                                    .foregroundStyle(
                                        preserveCase ? Color(.controlAccentColor) : Color(.secondaryLabelColor)
                                    )
                            }
                        )
                        .help(String(localized: "find.navigator.preserve.case.help", defaultValue: "Preserve Case", comment: "Help text for preserve case toggle in find navigator"))
                    },
                    clearable: true,
                    hasValue: preserveCase
                )
            }
            if scoped {
                PaneTextField(
                    String(localized: "find.navigator.only.in.folders.placeholder", defaultValue: "Only in folders", comment: "Placeholder text for include folders filter in find navigator"),
                    text: $includesText,
                    axis: .vertical,
                    leadingAccessories: {
                        Image(systemName: String(localized: "find.navigator.include.folders.icon", defaultValue: "folder.badge.plus", comment: "System icon name for include folders field in find navigator"))
                            .padding(.leading, 8)
                            .foregroundStyle(.tertiary)
                            .font(.system(size: 12))
                            .frame(width: 16, height: 20)
                    },
                    trailingAccessories: {
                        Divider()
                        Toggle(
                            isOn: $scopedToOpenEditors,
                            label: {
                                Image(systemName: String(localized: "find.navigator.open.editors.icon", defaultValue: "doc.plaintext", comment: "System icon name for search in open editors toggle in find navigator"))
                                    .foregroundStyle(
                                        scopedToOpenEditors ? Color(.controlAccentColor) : Color(.secondaryLabelColor)
                                    )
                            }
                        )
                        .help(String(localized: "find.navigator.open.editors.help", defaultValue: "Search only in Open Editors", comment: "Help text for search in open editors toggle in find navigator"))
                    },
                    clearable: true,
                    hasValue: scopedToOpenEditors
                )
                PaneTextField(
                    String(localized: "find.navigator.excluding.folders.placeholder", defaultValue: "Excluding folders", comment: "Placeholder text for exclude folders filter in find navigator"),
                    text: $excludesText,
                    axis: .vertical,
                    leadingAccessories: {
                        Image(systemName: String(localized: "find.navigator.exclude.folders.icon", defaultValue: "folder.badge.minus", comment: "System icon name for exclude folders field in find navigator"))
                            .padding(.leading, 8)
                            .foregroundStyle(.tertiary)
                            .font(.system(size: 12))
                            .frame(width: 16, height: 20)
                    },
                    trailingAccessories: {
                        Divider()
                        Toggle(
                            isOn: $excludeSettings,
                            label: {
                                Image(systemName: String(localized: "find.navigator.settings.icon", defaultValue: "gearshape", comment: "System icon name for exclude settings toggle in find navigator"))
                                    .foregroundStyle(
                                        excludeSettings ? Color(.controlAccentColor) : Color(.secondaryLabelColor)
                                    )
                            }
                        )
                        .help(String(localized: "find.navigator.exclude.settings.help", defaultValue: "Use Exclude Settings and Ignore Files", comment: "Help text for exclude settings toggle in find navigator"))
                    },
                    clearable: true,
                    hasValue: excludeSettings
                )
            }
            if selectedMode[0] == SearchModeModel.Replace {
                Button {
                    Task {
                        let startTime = Date()
                        try? await state.findAndReplace(query: state.searchQuery, replacingTerm: state.replaceText)
                        print(Date().timeIntervalSince(startTime))
                    }
                } label: {
                    Text(String(localized: "find.navigator.replace.all.button", defaultValue: "Replace All", comment: "Button label to replace all occurrences in find navigator"))
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .onReceive(state.$shouldFocusSearchField) { shouldFocus in
            if shouldFocus {
                isSearchFieldFocused = true
                state.shouldFocusSearchField = false
            }
        }
        .lineLimit(1...5)
    }
}

extension FindNavigatorForm {
    private func getMenuList(_ index: Int) -> [SearchModeModel] {
        index == 0 ? SearchModeModel.SearchModes : selectedMode[index - 1].children
    }

    private func onSelectMenuItem(_ index: Int, searchMode: SearchModeModel) {
        var newSelectedMode: [SearchModeModel] = []

        switch index {
        case 0:
                newSelectedMode.append(searchMode)
                self.updateSelectedMode(searchMode, searchModel: &newSelectedMode)
                self.selectedMode = newSelectedMode
        case 1:
            if let firstMode = selectedMode.first {
                newSelectedMode.append(contentsOf: [firstMode, searchMode])
                if let thirdMode = searchMode.children.first {
                    if let selectedThirdMode = selectedMode.third, searchMode.children.contains(selectedThirdMode) {
                        newSelectedMode.append(selectedThirdMode)
                    } else {
                        newSelectedMode.append(thirdMode)
                    }
                }
            }
            self.selectedMode = newSelectedMode
        case 2:
            if let firstMode = selectedMode.first, let secondMode = selectedMode.second {
                newSelectedMode.append(contentsOf: [firstMode, secondMode, searchMode])
            }
            self.selectedMode = newSelectedMode
        default:
            return
        }
    }

    private func updateSelectedMode(_ searchMode: SearchModeModel, searchModel: inout [SearchModeModel]) {
        if let secondMode = searchMode.children.first {
            if let selectedSecondMode = selectedMode.second, searchMode.children.contains(selectedSecondMode) {
                searchModel.append(contentsOf: selectedMode.dropFirst())
            } else {
                searchModel.append(secondMode)
                if let thirdMode = secondMode.children.first, let selectedThirdMode = selectedMode.third {
                    if secondMode.children.contains(selectedThirdMode) {
                        searchModel.append(selectedThirdMode)
                    } else {
                        searchModel.append(thirdMode)
                    }
                }
            }
        }
    }
}
