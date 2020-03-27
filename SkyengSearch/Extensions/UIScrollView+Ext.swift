import UIKit

extension UIScrollView {
    
    var isOverflowVertical: Bool {
        return contentSize.height > frame.height && frame.height > 0
    }
    
    func isReachedBottom(withTolerance tolerance: CGFloat = 0) -> Bool {
        guard isOverflowVertical else { return false }
        let contentOffsetBottom = contentOffset.y + frame.height
        return contentOffsetBottom >= contentSize.height - tolerance
    }
    
}
