//
//  AddTagView.swift
//  YBSFlickr
//
//  Created by Stefanos Sotiriou on 08/07/2024.
//

import SwiftUI

struct AddTagView: View {

    @Binding var tagText: String
    @ObservedObject var viewModel: PhotoListViewModel

    let columns = [GridItem(.adaptive(minimum: 80), spacing: 4)]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("Add Tag", text: $tagText, onCommit: {
                    if !tagText.isEmpty {
                        viewModel.searchTags.append(tagText)
                        viewModel.compositeSearch()
                        tagText = ""
                    }
                })
                .foregroundStyle(.accent)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: UIScreen.main.bounds.width / 2)
                .padding(.top, 20)
                // Picker to select match all tags option
                VStack {
                    Text("Match all tags")
                        .font(.footnote)
                        .foregroundStyle(.accent)
                    Picker("", selection: $viewModel.matchAllTags) {
                        Text("On").tag(true)
                        Text("Off").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(.alternativeAccent)
                    .cornerRadius(8)
                    .onChange(of: viewModel.matchAllTags) {
                        viewModel.compositeSearch()
                    }
                }
                .padding(.leading, 16)
            }
            .padding([.leading, .trailing], 16)
            // LazyVGrid to display the tags
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(viewModel.searchTags.indices, id: \.self) { index in
                    HStack(spacing: 4) {
                        Text(viewModel.searchTags[index])
                        Button(action: {
                            if let indexToRemove = viewModel.searchTags.firstIndex(of: viewModel.searchTags[index]) {
                                viewModel.searchTags.remove(at: indexToRemove)
                                viewModel.compositeSearch()
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.accent)
                        }
                        .padding(.leading, -4)
                    }
                    .padding(4)
                    .background(.alternativeAccent)
                    .cornerRadius(10)
                    .frame(minWidth: 80, maxWidth: 120)
                    .frame(width: calculateTagWidth(text: viewModel.searchTags[index]))
                }
            }
            .padding(.top, 10)
            .padding(.leading, 16)
        }
    }

    // Function to calculate the width of a tag based on its text

    private func calculateTagWidth(text: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 17)
        let textSize = (text as NSString).size(withAttributes: [.font: font])
        return min(textSize.width + 32 + 20, 120)
    }
}

