import UIKit

var greeting = "Hello, playground"

extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [unowned self] in
            self.transform = CGAffineTransform.init(scaleX: 0.0001, y: 0.001)
        }
    }
}

extension Int {
    func times(_ block: () -> Void) {
        guard self > 0 else { return }
        
        for _ in 0..<self {
            block()
        }
    }
}

extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        if let index = self.firstIndex(of: item) {
            self.remove(at: index)
        }
    }
}

let view = UIView()
view.bounceOut(duration: 3)

3.times {
    print("Yeah!")
}

var arr = ["Hello", "How are you?", "Hello", "Godd morning!", "Some other test case"]
arr.remove(item: "Hello")
print(arr)
arr.remove(item: "Hello")
print(arr)
