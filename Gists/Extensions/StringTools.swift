import Foundation
import UIKit

extension String {

    static var Empty = ""

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    var dateFromISO8601: Date? {
        let formatter = ISO8601DateFormatter()
        var result = formatter.date(from: self)
        if result != nil {
            return result
        }

        if let utcDate =  formatter.date(from: self + "Z") {
            let sign =  TimeZone.current.secondsFromGMT(for: utcDate) > 0 ? "+" : "-"
            let hours = abs( TimeZone.current.secondsFromGMT(for: utcDate) / 3600 )
            let minutes = abs( TimeZone.current.secondsFromGMT(for: utcDate) / 60 ) - hours * 60

            let updatedStrDate = self + String(format: "%@%02d:%02d", arguments: [sign, hours, minutes])
            result = formatter.date(from: updatedStrDate )
        }

        return result
    }
    
    var html2AttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options:
                [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                 NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }

    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)

        let option = NSStringDrawingOptions.usesLineFragmentOrigin // NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)

        let boundingBox = self.boundingRect(with: constraintRect, options: option, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }

    func attributed() -> NSAttributedString {
        return NSAttributedString(string: self)
    }

    func attributedWith(color: UIColor? = nil, font: UIFont? = nil) -> NSAttributedString {
        var result = self.attributed()
        if let color = color {
            result = result.color(color)
        }

        if let font = font {
            result = result.font(font)
        }

        return result
    }

}

extension NSAttributedString {
    func strikethrough() -> NSAttributedString {
        let result = NSMutableAttributedString()
        result.append(self)
        result.addAttributes([NSStrikethroughStyleAttributeName: 1], range: NSRange(location: 0, length: result.length))
        return result
    }

    func color(_ color: UIColor) -> NSAttributedString {
        let result = NSMutableAttributedString()
        result.append(self)
        result.addAttributes([NSForegroundColorAttributeName: color], range: NSRange(location: 0, length: result.length))
        return result
    }

    func font(_ font: UIFont) -> NSAttributedString {
        let result = NSMutableAttributedString()
        result.append(self)
        result.addAttributes([NSFontAttributeName: font], range: NSRange(location: 0, length: result.length))
        return result
    }
}

extension Date {
    var iso8601: String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }

    public func toString(as format: String, timezone: String = "") -> String {
        let formatter = DateFormatter()
        if !timezone.isEmpty {
            formatter.timeZone = TimeZone(identifier: timezone)
        }
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
