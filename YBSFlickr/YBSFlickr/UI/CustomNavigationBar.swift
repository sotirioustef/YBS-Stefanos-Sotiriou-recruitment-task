//
//  CustomNavigationBar.swift
//  YBSFlickr
//
//  Created by Stefanos Sotiriou on 07/07/2024.
//

import SwiftUI

struct CustomNavigationBar: View {
    var showBackButton: Bool
    var backAction: (() -> Void)?
    var imageName: String
    
    var body: some View {
        HStack {
            if showBackButton {
                Button(action: {
                    backAction?()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(.blue)
                }
                .padding(.leading, 16)
            }
            Spacer()
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 40)
            Spacer()
            if showBackButton {
                Spacer()
            }
        }
        .padding(.top, 5)
        .background(.white)
    }
}
