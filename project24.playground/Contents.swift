import UIKit

let attribbutes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.systemBlue,
    .font: UIFont.boldSystemFont(ofSize: 36),
]

let coloredString = NSAttributedString(string: " This is a colorful string! ", attributes: attribbutes)

let growingString = NSMutableAttributedString(string: "This is a growing string")
growingString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8) , range: NSRange(location: 0, length: 4))
growingString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16) , range: NSRange(location: 5, length: 2))
growingString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24) , range: NSRange(location: 8, length: 1))
growingString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32) , range: NSRange(location: 10, length: 7))
growingString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40) , range: NSRange(location: 18, length: 6))


extension String {
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) { return self }
        return prefix + self
    }
    
    func isNumeric() -> Bool {
        return Int(self) != nil || Double(self) != nil
    }
    
    var lines: [String] { self.components(separatedBy: "\n") }
}


"Hello".withPrefix("He")
"pet".withPrefix("car")

"No".isNumeric()
"10".isNumeric()
"10.5".isNumeric()

"this\nis\na\ntest".lines
