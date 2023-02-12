// ChatBottomArea+PhotosScroll.swift

import SwiftUI

extension ChatBottomArea {
    @ViewBuilder var photosScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .center, spacing: 5) {
                ForEach(viewModel.displayedImages) { photo in
                    photo.image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .transition(.scale.combined(with: .opacity))
                        .matchedGeometryEffect(id: "\(photo.id)", in: rootViewModel.namespace)
                        .onTapGesture {
                            withAnimation {
                                let items = viewModel.displayedImages.map {
                                    IdentifiableImage(id: "\($0.id)", image: $0.image)
                                }
                                let index = items.firstIndex(where: { $0.id == "\(photo.id)" }) ?? 0
                                rootViewModel.openedItems = OpenedItems(
                                    images: items,
                                    index: index
                                )
                            }
                        }
                        .overlay(alignment: .topTrailing) {
                            Button {
                                withAnimation {
                                    viewModel.displayedImages.removeAll(where: { photo.id == $0.id })
                                }
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                                    .padding(5)
                            }
                        }
                }
            }
        }
        .frame(height: 120)
        .cornerRadius(15)
        .padding(5)
        .background(.gray6)
        .cornerRadius(15)
    }
}
