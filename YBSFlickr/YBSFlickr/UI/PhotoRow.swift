//
//  PhotoRow.swift
//  YBSFlickr
//
//  Created by Stefanos Sotiriou on 08/07/2024.
//

import SwiftUI

struct PhotoRow: View {
    var photo: Photo
    var showTags: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: photo.mediumUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
            } placeholder: {
                Color.gray
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
            }
            HStack {
                AsyncImage(url: URL(string: photo.ownerIconUrl)) { image in
                    image
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.white, lineWidth: 1))
                } placeholder: {
                    Circle()
                        .fill(.gray)
                        .frame(width: 40, height: 40)
                }
                VStack(alignment: .leading) {
                    Text(photo.ownername ?? "")
                        .font(.footnote)
                        .foregroundStyle(.black)
                    Text(photo.owner)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                .padding([.leading, .trailing], 0)
            }
            .padding([.top, .bottom], 8)
            // Display the tags if showTags is true and there are tags available
            if showTags, let tags = photo.tags, !tags.isEmpty {
                TagListView(tags: tags)
                    .padding(.top, 0)
                    .padding(.bottom, 16)
            }
        }
    }
}

