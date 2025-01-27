// ChatBottomArea+LeftSide.swift

import SwiftUI
import PhotosUI

extension ChatBottomArea {
    @ViewBuilder var leftSide: some View {
        Button {
            viewModel.showBottomSheet = true
            Task {
                await viewModel.getImages()
            }
        } label: {
            Image(systemName: "paperclip")
                .font(.title3)
                .foregroundColor(.white)
                .contentShape(Rectangle())
        }
        .disabled(!redactionReasons.isEmpty)
        .unredacted()
    }
}
