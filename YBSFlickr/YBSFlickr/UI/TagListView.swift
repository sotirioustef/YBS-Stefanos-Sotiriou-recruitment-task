//
//  TagListView.swift
//  YBSFlickr
//
//  Created by Stefanos Sotiriou on 08/07/2024.
//

import SwiftUI

import SwiftUI

struct TagListView: View {
    let tags: String
    
    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
        .padding(.horizontal, 8)
    }
    
    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var rows: [[String]] = [[]]
        for tag in tags.split(separator: " ").map(String.init) {
            let tagWidth = textWidth(tag, font: .systemFont(ofSize: 17)) + 32
            if width + tagWidth + 8 > geometry.size.width {
                width = 0
                rows.append([])
            }
            rows[rows.count - 1].append(tag)
            width += tagWidth
        }
        
        return VStack(alignment: .leading, spacing: 4) {
            ForEach(0..<rows.count, id: \.self) { rowIndex in
                HStack(spacing: 4) {
                    ForEach(rows[rowIndex], id: \.self) { tag in
                        Text(tag)
                            .padding(8)
                            .background(.alternativeAccent)
                            .foregroundStyle(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
    
    private func textWidth(_ text: String, font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        return size.width
    }
}
