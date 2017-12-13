import Foundation
extension Double {
    func asCurrency(withSymbol currencySymbol: String, minDecimalNumbers: Int = 0) -> String {
        let nf = NumberFormatter()
        nf.currencySymbol = currencySymbol
        nf.numberStyle = .none
        nf.minimumFractionDigits = minDecimalNumbers
        nf.maximumFractionDigits = 2
        let displayValue = nf.string(from: NSNumber(value: self)) ?? "\(self)"
        return "\(currencySymbol)\u{200A}\(displayValue)"
    }
    
    func asCurrencyWithCode(withSymbol currencySymbol: String, currencyCode: String, minDecimalNumbers: Int = 0) -> String {
        var result = self.asCurrency(withSymbol: currencySymbol, minDecimalNumbers: minDecimalNumbers)
        if !currencyCode.isEmpty {
            result.append(" (\(currencyCode))")
        }
        return result
    }
}
