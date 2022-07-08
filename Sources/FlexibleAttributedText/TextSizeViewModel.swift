import SwiftUI

final class TextSizeViewModel: ObservableObject {
  @Published var textSize: CGSize?

  func didUpdateTextView(_ textView: FlexibleAttributedTextImpl.TextView) {
    textSize = textView.intrinsicContentSize
  }
}
