//
//  PhotoScrollView.swift
//  YBSFlickr
//
//  Created by Stefanos Sotiriou on 08/07/2024.
//

import SwiftUI

struct PhotoScrollView: View {
    @ObservedObject var viewModel: PhotoListViewModel
    @Binding var viewMode: ViewMode
    
    var body: some View {
        ScrollView {
            if viewMode == .grid {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(viewModel.photos) { photo in
                        NavigationLink(destination: PhotoDetailsView(viewModel: viewModel, photo: photo)) {
                            PhotoRow(photo: photo, showTags: false)
                        }
                    }
                }
                .padding()
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.photos) { photo in
                        NavigationLink(destination: PhotoDetailsView(viewModel: viewModel, photo: photo)) {
                            PhotoRow(photo: photo, showTags: true)
                        }
                    }
                }
                .padding()
            }
        }
    }
}
