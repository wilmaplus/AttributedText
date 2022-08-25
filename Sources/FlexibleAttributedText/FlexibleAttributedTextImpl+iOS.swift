#if os(iOS)
  import SwiftUI
  import UIKit

  extension FlexibleAttributedTextImpl: UIViewRepresentable {
    func makeUIView(context: Context) -> TextView {
      TextView()
    }

    func updateUIView(_ uiView: TextView, context: Context) {
      uiView.attributedText = attributedText
      uiView.maxLayoutWidth = maxLayoutWidth
      uiView.textContainer.maximumNumberOfLines = context.environment.lineLimit ?? 0
      uiView.textContainer.lineBreakMode = NSLineBreakMode(
        truncationMode: context.environment.truncationMode
      )
        uiView.isSelectable = contentIsSelectable
      if let color = linkColor {
        uiView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: color]
      }
      uiView.openLink = onOpenLink ?? { context.environment.openURL($0) }
      uiView.invalidateIntrinsicContentSize()
      uiView.updateFrame()
      textSizeViewModel.didUpdateTextView(uiView)
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

      var openLink: ((URL) -> Void)?

      var linkColor: UIColor?


      override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)

        self.backgroundColor = .clear
        self.textContainerInset = .zero
        self.isEditable = false
        self.isSelectable = false
        self.isScrollEnabled = false
        self.textContainer.lineFragmentPadding = 0
        self.updateFrame()
        self.addGestureRecognizer(
          UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        )
      }

      required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      }

      func updateFrame() {
        if let color = linkColor {
            linkTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        }
        let fixedWidth = frame.size.width
        let newSize = self.sizeThatFits(
          CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        self.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
      }

      override var intrinsicContentSize: CGSize {
        guard maxLayoutWidth > 0 else {
          let fixedWidth = frame.size.width
          let newSize = self.sizeThatFits(
            CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
          return CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        }

        return sizeThatFits(CGSize(width: maxLayoutWidth, height: .greatestFiniteMagnitude))
      }

      @objc func handleTap(sender: UITapGestureRecognizer) {
        guard let url = self.url(at: sender.location(in: self)) else {
          return
        }
        openLink?(url)
      }

      private func url(at location: CGPoint) -> URL? {
        guard let attributedText = self.attributedText else { return nil }

        let index = indexOfCharacter(at: location)
        return attributedText.attribute(.link, at: index, effectiveRange: nil) as? URL
      }

      private func indexOfCharacter(at location: CGPoint) -> Int {
        let locationInTextContainer = CGPoint(
          x: location.x - self.textContainerInset.left,
          y: location.y - self.textContainerInset.top
        )
        return self.layoutManager.characterIndex(
          for: locationInTextContainer,
          in: self.textContainer,
          fractionOfDistanceBetweenInsertionPoints: nil
        )
      }
    }
  }
#endif
