//
//  NoResultsView.swift
//  YBSFlickr
//
//  Created by Stefanos Sotiriou on 08/07/2024.
//

import SwiftUI

struct NoResultsView: View {
    var body: some View {
        VStack {
            VStack {
                Image(systemName: "magnifyingglass")
                    .font(.largeTitle)
                    .padding(.bottom, 8)
                Text("No Results Found.")
                    .font(.headline)
                    .padding(.bottom, 2)
                Text("Wow. We've searched high and low, but can't seem to find what you're looking for right now.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
            Spacer().frame(height: 250)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .edgesIgnoringSafeArea(.all)
    }
}
