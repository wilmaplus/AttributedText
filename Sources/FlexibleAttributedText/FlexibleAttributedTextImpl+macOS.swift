#if os(macOS)
  import SwiftUI

  extension FlexibleAttributedTextImpl: NSViewRepresentable {
    func makeNSView(context: Context) -> TextView {
      let nsView = TextView(frame: .zero)

      nsView.drawsBackground = false
      nsView.textContainerInset = .zero
      nsView.isEditable = false
      nsView.isSelectable = contentIsSelectable
      nsView.isRichText = false
      nsView.textContainer?.lineFragmentPadding = 0
      // we are setting the container's width manually
      nsView.textContainer?.widthTracksTextView = false
      nsView.delegate = context.coordinator

      return nsView
    }

    func updateNSView(_ nsView: TextView, context: Context) {
      nsView.textStorage?.setAttributedString(attributedText)
      nsView.maxLayoutWidth = maxLayoutWidth
      if let color = linkColor {
        nsView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: color]
      }
      nsView.textContainer?.maximumNumberOfLines = context.environment.lineLimit ?? 0
      nsView.textContainer?.lineBreakMode = NSLineBreakMode(
        truncationMode: context.environment.truncationMode
      )
      context.coordinator.openLink = onOpenLink ?? { context.environment.openURL($0) }
        nsView.invalidateIntrinsicContentSize()
      textSizeViewModel.didUpdateTextView(nsView)
    }

    func makeCoordinator() -> Coordinator {
      Coordinator()
    }
  }

  extension FlexibleAttributedTextImpl {
    final class TextView: NSTextView {
      var maxLayoutWidth: CGFloat {
        get { textContainer?.containerSize.width ?? 0 }
        set {
          guard textContainer?.containerSize.width != newValue else { return }
          textContainer?.containerSize.width = newValue
          invalidateIntrinsicContentSize()
        }
      }

      override var intrinsicContentSize: CGSize {
        guard maxLayoutWidth > 0,
          let textContainer = self.textContainer,
          let layoutManager = self.layoutManager
        else {
          let fixedWidth = frame.size.width
          let newSize = self.sizeThatFits(
            CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
          return CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        }

        layoutManager.ensureLayout(for: textContainer)
        return layoutManager.usedRect(for: textContainer).size
      }

      final class Coordinator: NSObject, NSTextViewDelegate {
        var openLink: ((URL) -> Void)?

        func textView(_: NSTextView, clickedOnLink link: Any, at _: Int) -> Bool {
          guard let openLink = self.openLink,
            let url = (link as? URL) ?? (link as? String).flatMap(URL.init(string:))
          else {
            return false
          }

          openLink(url)
          return true
        }
      }
    }
  }
#endif
