import UIKit

extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [unowned self] in
            self.transform.scaledBy(x: 0.0001, y: 0.0001)
        }
    }
}

extension Int {
    func times(_ closure: (() -> ())) {
        guard self > 0 else { return }
        for _ in 0 ..< self {
            closure()
        }
    }
}

5.times {
    print("Hello!")
}

extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        if let index = self.firstIndex(of: item) {
            self.remove(at: index)
        }
    }
}

var array = [0, 1, 2, 1, 3]
array.remove(item: 1)
print(array)
