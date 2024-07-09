//
//  SearchBar.swift
//  YBSFlickr
//
//  Created by Stefanos Sotiriou on 04/07/2024.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    @Binding var isActive: Bool
    var placeholder: String
    var onSearchButtonClicked: () -> Void
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        @Binding var isActive: Bool
        var onSearchButtonClicked: () -> Void
        
        init(text: Binding<String>, isActive: Binding<Bool>, onSearchButtonClicked: @escaping () -> Void) {
            _text = text
            _isActive = isActive
            self.onSearchButtonClicked = onSearchButtonClicked
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            isActive = true
        }
        
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            isActive = false
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            onSearchButtonClicked()
            searchBar.resignFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, isActive: $isActive, onSearchButtonClicked: onSearchButtonClicked)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .accent
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .accent
            textField.tintColor = .accent
        }
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}
