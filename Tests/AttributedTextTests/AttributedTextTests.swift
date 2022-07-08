#if !os(macOS) && !targetEnvironment(macCatalyst)
  import SnapshotTesting
  import SwiftUI
  import XCTest

  import AttributedText

  final class AttributedTextTests: XCTestCase {
    struct TestView: View {
        var flexible: Bool = false
      var body: some View {
          AttributedText(attributedText: {
          let result = NSMutableAttributedString(
            string: """
              Sherlock Holmes
              I had called upon my friend, Mr. Sherlock Holmes.
              """
          )

          result.addAttributes(
            [.font: UIFont.preferredFont(forTextStyle: .title2)],
            range: NSRange(location: 0, length: 15)
          )
          result.addAttributes(
            [.font: UIFont.preferredFont(forTextStyle: .body)],
            range: NSRange(location: 15, length: 49)
          )
          return result
          }, onOpenLink: nil, flexibleWidth: flexible)
        .background(Color.gray.opacity(0.5))
        .padding()
      }
    }

    private let precision: Float = 0.99

    #if os(iOS)
      private let layout = SwiftUISnapshotLayout.device(config: .iPhone8)
      private let platformName = "iOS"
    #elseif os(tvOS)
      private let layout = SwiftUISnapshotLayout.device(config: .tv)
      private let platformName = "tvOS"
    #endif

    func testHeight() {
      let view = TestView()
      assertSnapshot(
        matching: view, as: .image(precision: precision, layout: layout), named: platformName)
    }

    func testLineLimit() {
      let view = TestView()
        .lineLimit(2)
      assertSnapshot(
        matching: view, as: .image(precision: precision, layout: layout), named: platformName)
    }

    func testTruncationMode() {
      let view = TestView()
        .lineLimit(2)
        .truncationMode(.middle)
      assertSnapshot(
        matching: view, as: .image(precision: precision, layout: layout), named: platformName)
    }
      
      func testFlexible() {
          let view = TestView(flexible: true)
              .frame(minWidth: 0, maxWidth: .infinity).background(Color.red)
        assertSnapshot(
          matching: view, as: .image(precision: precision, layout: layout), named: platformName)
      }
      
      func testFlexibleWidthWithAlignment() {
          let view = VStack(alignment: .leading) {
              TestView(flexible: true)
          }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).background(Color.red)

        assertSnapshot(
          matching: view, as: .image(precision: precision, layout: layout), named: platformName)
      }
  }
#endif
