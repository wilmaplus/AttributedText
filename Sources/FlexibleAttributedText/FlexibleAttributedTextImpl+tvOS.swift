#if os(tvOS)
  import SwiftUI

  extension FlexibleAttributedTextImpl: UIViewRepresentable {
    func makeUIView(context: Context) -> TextView {
      let uiView = TextView()

      uiView.backgroundColor = .clear
      uiView.textContainerInset = .zero
      uiView.isScrollEnabled = false
      uiView.textContainer.lineFragmentPadding = 0
      uiView.delegate = context.coordinator

      return uiView
    }

    func updateUIView(_ uiView: TextView, context: Context) {
      uiView.attributedText = attributedText
      uiView.maxLayoutWidth = maxLayoutWidth

      uiView.textContainer.maximumNumberOfLines = context.environment.lineLimit ?? 0
      uiView.textContainer.lineBreakMode = NSLineBreakMode(
        truncationMode: context.environment.truncationMode
      )
      context.coordinator.openLink = onOpenLink ?? { context.environment.openURL($0) }
      textSizeViewModel.didUpdateTextView(uiView)
    }

    func makeCoordinator() -> Coordinator {
      Coordinator()
    }
  }

  extension FlexibleAttributedTextImpl {
    final class TextView: UITextView {
      var maxLayoutWidth: CGFloat = 0 {
        didSet {
          guard maxLayoutWidth != oldValue else { return }
          invalidateIntrinsicContentSize()
        }
      }

      override var intrinsicContentSize: CGSize {
        guard maxLayoutWidth > 0 else {
          return sizeThatFits(
            CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        }

        return sizeThatFits(CGSize(width: maxLayoutWidth, height: .greatestFiniteMagnitude))
      }
    }

    final class Coordinator: NSObject, UITextViewDelegate {
      var openLink: ((URL) -> Void)?

      func textView(
        _: UITextView,
        shouldInteractWith URL: URL,
        in _: NSRange,
        interaction: UITextItemInteraction
      ) -> Bool {
        guard case .invokeDefaultAction = interaction else {
          return false
        }

        if let openLink = self.openLink {
          openLink(URL)
          return false
        } else {
          return true
        }
      }

      func textView(
        _: UITextView,
        shouldInteractWith _: NSTextAttachment,
        in _: NSRange,
        interaction _: UITextItemInteraction
      ) -> Bool {
        // Disable text attachment interactions
        false
      }
    }
  }
#endif
