import SwiftUI

/// A view that displays styled attributed text.
public struct FlexibleAttributedText: View {
  @StateObject private var textSizeViewModel = TextSizeViewModel()

  private let attributedText: NSAttributedString
  private let onOpenLink: ((URL) -> Void)?
  private let flexibleWidth: Bool

  /// Creates an attributed text view.
  /// - Parameters:
  ///   - attributedText: An attributed string to display.
  ///   - onOpenLink: The action to perform when the user opens a link in the text. When not specified,
  ///                 the  view opens the links using the `OpenURLAction` from the environment.
  ///   - flexibleWidth: Flexible Width
  public init(
    _ attributedText: NSAttributedString, onOpenLink: ((URL) -> Void)? = nil,
    flexibleWidth: Bool = false
  ) {
    self.attributedText = attributedText
    self.onOpenLink = onOpenLink
    self.flexibleWidth = flexibleWidth
  }

  /// Creates an attributed text view.
  /// - Parameters:
  ///   - attributedText: A closure that creates the attributed string to display.
  ///   - onOpenLink: The action to perform when the user opens a link in the text. When not specified,
  ///                 the  view opens the links using the `OpenURLAction` from the environment.
  ///   - flexibleWidth: Flexible Width
  public init(
    attributedText: () -> NSAttributedString, onOpenLink: ((URL) -> Void)? = nil,
    flexibleWidth: Bool = false
  ) {
    self.init(attributedText(), onOpenLink: onOpenLink, flexibleWidth: flexibleWidth)
  }

  public var body: some View {
    GeometryReader { geometry in
      FlexibleAttributedTextImpl(
        attributedText: attributedText,
        maxLayoutWidth: geometry.maxWidth,
        textSizeViewModel: textSizeViewModel,
        onOpenLink: onOpenLink
      )
    }
    .frame(
      idealWidth: textSizeViewModel.textSize?.width,
      maxWidth: flexibleWidth ? textSizeViewModel.textSize?.width : CGFloat(MAXFLOAT),
      idealHeight: textSizeViewModel.textSize?.height
    )
    .fixedSize(horizontal: false, vertical: true)
  }
}

extension GeometryProxy {
  fileprivate var maxWidth: CGFloat {
    size.width - safeAreaInsets.leading - safeAreaInsets.trailing
  }
}
