import Foundation

extension Date {
  func toString() -> String {
 let datefromat = DateFormatter()
    datefromat.dateFormat = "yyyy-MM-dd"
    let now = datefromat.string(from: self)
    return now
  }
}

extension String {
    // swiftlint:disable:next no_date_instantiation
  func toDate() -> Date? {
    if self == "" { return nil}
    let dateFormatter = DateFormatter()
         dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    // set locale to reliable US_POSIX
         dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
         let date = dateFormatter.date(from: self)

    return date
  }
}
