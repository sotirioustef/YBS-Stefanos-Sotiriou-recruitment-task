//
//  PhotoDetailsView.swift
//  YBSFlickr
//
//  Created by Stefanos Sotiriou on 04/07/2024.
//

import SwiftUI

struct PhotoDetailsView: View {

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: PhotoListViewModel
    var photo: Photo

    var body: some View {
        VStack {
            header
            photoTitle
            photoImage
            photoDetails
        }
        .background(.black)
        .navigationBarHidden(true)
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            ownerImage
            ownerDetails
            Spacer()
            closeButton
        }
        .onTapGesture {
            searchByUsername()
        }
        .padding()
    }

    // MARK: - Owner Image

    private var ownerImage: some View {
        AsyncImage(url: URL(string: photo.ownerIconUrl)) { image in
            image
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .overlay(Circle().stroke(.white, lineWidth: 1))
        } placeholder: {
            Circle()
                .fill(.gray)
                .frame(width: 50, height: 50)
        }
    }

    // MARK: - Owner Details

    private var ownerDetails: some View {
        VStack(alignment: .leading) {
            Text(photo.ownername ?? "")
                .font(.headline)
                .foregroundStyle(.white)
            Text(photo.owner)
                .font(.subheadline)
                .foregroundStyle(.white)
        }
    }

    // MARK: - Close Button

    private var closeButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark")
                .foregroundStyle(.white)
                .padding()
        }
    }

    // MARK: - Photo Title

    private var photoTitle: some View {
        Text(photo.title)
            .font(.title)
            .foregroundStyle(.white)
            .padding(.top, 16)
    }

    // MARK: - Photo Image

    private var photoImage: some View {
        AsyncImage(url: URL(string: photo.largeUrl)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
        } placeholder: {
            Color.gray
                .frame(maxWidth: .infinity)
        }
        .onTapGesture {
            searchByUsername()
        }
    }

    // MARK: - Photo Details

    private var photoDetails: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let dateTaken = photo.datetaken, !dateTaken.isEmpty {
                Text("Date Taken: \(formattedDate(dateTaken))")
                    .foregroundStyle(.white)
                    .padding(.top, 4)
                    .font(.subheadline)
            }
            if !photo.description._content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text("Description:")
                    .foregroundStyle(.white)
                    .padding(.top, 4)
                    .font(.title)
                Text(photo.description._content)
                    .foregroundStyle(.white)
                    .padding(.top, 4)
            }
            if photo.tags != "" && photo.tags != nil {
                TagListView(tags: photo.tags ?? "")
                Spacer()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Private Methods

    private func searchByUsername() {
        viewModel.setSearchTypeAndQuery(type: .username, query: photo.ownername ?? "")
        viewModel.compositeSearch()
        presentationMode.wrappedValue.dismiss()
    }

    private func formattedDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
        }
        return dateString
    }
}
