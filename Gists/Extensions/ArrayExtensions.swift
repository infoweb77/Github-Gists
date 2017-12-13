import Foundation

public extension Array {
    func take(_ maxCount: Int) -> ArraySlice<Element> {
        return self[0..<Swift.min(maxCount, self.count)]
    }

    func concat(_ another: Array) -> [Element] {
        var result: [Element] = []
        result.append(contentsOf: self)
        result.append(contentsOf: another)
        return result
    }

    func groupBy<G: Hashable>(groupClosure: (Element) -> G) -> [G: [Element]] {
        var dictionary = [G: [Element]]()

        for element in self {
            let key = groupClosure(element)
            var array: [Element]? = dictionary[key]

            if array == nil {
                array = [Element]()
            }

            array!.append(element)
            dictionary[key] = array!
        }

        return dictionary
    }
}

extension Array where Element : Hashable {
    func distinct() -> [Element] {
        return [Element](Set<Element>(self))
    }
}