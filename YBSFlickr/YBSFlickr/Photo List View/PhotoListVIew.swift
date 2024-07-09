//
//  PhotoListVIew.swift
//  YBSFlickr
//
//  Created by Stefanos Sotiriou on 04/07/2024.
//

import SwiftUI

enum ViewMode {
    case grid
    case list
}

struct PhotoListView: View {
    @ObservedObject var viewModel = PhotoListViewModel()
    @State private var tagText = ""
    @State private var isTagSectionVisible = false
    @State private var isMenuActive = false
    @State private var isSearchFieldActive = false
    @State private var isSearchTypeMenuActive = false
    @Namespace var animation
    @State private var selected: Photo?
    @State private var viewMode: ViewMode = .grid

    var body: some View {
        NavigationStack {
            VStack {
                CustomNavigationBar(showBackButton: false, imageName: "AlternativeAppIcon")
                searchTypeMenu
                searchBar
                HStack {
                    addTagsSection
                    safeSearchSection
                    Spacer()
                    viewModeButtons
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                if isTagSectionVisible {
                    AddTagView(tagText: $tagText, viewModel: viewModel)
                }
                if viewModel.photos.isEmpty {
                    NoResultsView()
                } else {
                    PhotoScrollView(viewModel: viewModel, viewMode: $viewMode)
                }
            }
            .onAppear {
                if viewModel.photos.isEmpty {
                    viewModel.searchQuery = "Yorkshire"
                    self.viewModel.searchByText(query: "Yorkshire")
                }
            }
        }
    }

    // MARK: - Search Type Menu

    private var searchTypeMenu: some View {
        HStack {
            Menu {
                Button("Text") {
                    viewModel.searchType = .text
                    viewModel.searchQuery = ""
                    isSearchTypeMenuActive = false
                }
                Button("Username") {
                    viewModel.searchType = .username
                    viewModel.searchQuery = ""
                    isSearchTypeMenuActive = false
                }
            } label: {
                HStack {
                    Text("Search by: \(viewModel.searchType == .text ? "Text" : "Username")")
                        .font(.footnote)
                        .foregroundStyle(.accent)
                    Image(systemName: isSearchTypeMenuActive ? "minus.circle.fill" : "plus.circle.fill")
                        .foregroundStyle(.alternativeAccent)
                        .font(.footnote)
                        .animation(.easeInOut, value: isSearchTypeMenuActive)
                        .padding(.leading, -5)
                }
            }
            .onTapGesture {
                withAnimation {
                    isSearchTypeMenuActive.toggle()
                }
            }
            Spacer()
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack {
            SearchBar(text: $viewModel.searchQuery, isActive: $isSearchFieldActive, placeholder: "Search Text") {
                viewModel.compositeSearch()
            }
            if isSearchFieldActive {
                Button(action: {
                    hideKeyboard()
                    isSearchFieldActive = false
                }) {
                    Text("Cancel")
                        .foregroundStyle(.alternativeAccent)
                }
                .padding(.trailing, 8)
            }
        }
        .padding(.top, 8)
    }

    // MARK: - Add Tags Section

    private var addTagsSection: some View {
        HStack {
            Text("Add Tags")
                .font(.footnote)
                .foregroundStyle(.accent)
                .onTapGesture {
                    withAnimation {
                        isTagSectionVisible.toggle()
                    }
                }
            ZStack {
                Image(systemName: isTagSectionVisible ? "minus.circle.fill" : "plus.circle.fill")
                    .foregroundStyle(.alternativeAccent)
                    .font(.footnote)
                    .animation(.easeInOut, value: isTagSectionVisible)
            }
            .frame(width: 10, height: 10)
            .padding(.leading, -5)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }

    // MARK: - Safe Search Section

    private var safeSearchSection: some View {
        HStack {
            Menu {
                Button("Safe", action: {
                    viewModel.safeSearch = "1"
                    viewModel.compositeSearch()
                })
                Button("Moderate", action: {
                    viewModel.safeSearch = "2"
                    viewModel.compositeSearch()
                })
                Button("Restricted", action: {
                    viewModel.safeSearch = "3"
                    viewModel.compositeSearch()
                })
            } label: {
                HStack {
                    Text("Safe Search \(safeSearchText())")
                        .font(.footnote)
                        .foregroundStyle(.accent)
                    Image(systemName: isMenuActive ? "minus.circle.fill" : "plus.circle.fill")
                        .foregroundStyle(.alternativeAccent)
                        .font(.footnote)
                        .animation(.easeInOut, value: isMenuActive)
                        .padding(.leading, -5)
                }
            }
            .onTapGesture {
                withAnimation {
                    isMenuActive.toggle()
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }

    // MARK: - View Mode Buttons

    private var viewModeButtons: some View {
        HStack {
            Button(action: {
                viewMode = .grid
            }) {
                Image(systemName: "square.grid.2x2")
                    .foregroundStyle(viewMode == .grid ? .alternativeAccent : .gray)
            }
            Button(action: {
                viewMode = .list
            }) {
                Image(systemName: "list.bullet")
                    .foregroundStyle(viewMode == .list ? .alternativeAccent : .gray)
            }
        }
    }

    // MARK: - Helper Methods

    private func safeSearchText() -> String {
        switch viewModel.safeSearch {
        case "1":
            return "on"
        case "2":
            return "moderate"
        case "3":
            return "off"
        default:
            return "on"
        }
    }
}

// Keyboard Extension

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
