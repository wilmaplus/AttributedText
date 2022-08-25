import SwiftUI
import UIKit

struct FlexibleAttributedTextImpl {
  var attributedText: NSAttributedString
  var maxLayoutWidth: CGFloat
  var textSizeViewModel: TextSizeViewModel
  var onOpenLink: ((URL) -> Void)?
  var linkColor: UIColor?
  var contentIsSelectable: Bool
}
