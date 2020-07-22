import Foundation
import CoreData

protocol CharachterListViewModel {
    var isOffline: Dynamic<Bool> { get }
    var noOfCharachters: Dynamic<Int> { get }
    var isCharachterDataLoading: Dynamic<Bool> { get }
    var errorCharachter: Dynamic<String> { get }
    var charachterListApiTotal: Dynamic<Int> { get }

  func getSelectedCharachterViewModel(atIndex indexpath: Int) -> ResultCharachter

    func fetchCharachterList()
    func fetchMoreCharachters()
    func refreshCharachterList()
}
