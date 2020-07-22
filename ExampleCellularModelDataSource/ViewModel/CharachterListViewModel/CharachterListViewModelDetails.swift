import Foundation
import Reachability

class CharachterListViewModelDetails: NSObject, CharachterListViewModel {
  weak var appDelegate = UIApplication.shared.delegate as? AppDelegate

  private var apiService = URLSessionAPIService()
  private var charachterList: [ResultCharachter] = []
  private var charachterListDataSource: [CharachterDBModel] = []
  private var charachterListApiOffset = 0
  private var charachterListApiLimit = 20

  var isOffline: Dynamic<Bool>
  var noOfCharachters: Dynamic<Int>
  var isCharachterDataLoading: Dynamic<Bool>
  var charachterListApiTotal: Dynamic<Int>
  var errorCharachter: Dynamic<String>

  override init() {
    isOffline = Dynamic(false)
    isCharachterDataLoading = Dynamic(false)
    noOfCharachters = Dynamic(0)
    charachterListApiTotal = Dynamic(0)
    errorCharachter = Dynamic("")

    super.init()
  }

  func getSelectedCharachterViewModel(atIndex indexpath: Int) -> ResultCharachter {
    return charachterList[indexpath-1]
  }
  func fetchMoreCharachters() {
    if !isCharachterDataLoading.value {
      //            self.charachterListApiOffset += 20
      self.charachterListApiLimit += 20
      fetchCharachterList()
    }
  }

  func refreshCharachterList() {
    self.charachterListApiOffset = 0
    self.charachterListApiLimit = 20
    self.charachterList = []
    self.charachterListDataSource = []
    fetchCharachterList()
  }

  func fetchCharachterList() {
    let reachability = try? Reachability()
    if (reachability?.connection) == .unavailable && charachterList.count == 0 {

//        self.charachterListDataSource = charFromDb!
        self.charachterListApiOffset = self.charachterListDataSource.count
        self.noOfCharachters.value = self.charachterListDataSource.count
        return

    }
    self.isCharachterDataLoading.value = true
    apiService.dispatch(apiRequest: MarvelRequestsEndPoint.charachterList(offset:
        charachterListApiOffset, limit: charachterListApiLimit)) { (data, response, error) in
      if let data = data {
        do {
          let charachterList = try JSONDecoder().decode(ResponseJson<ResultCharachter>.self, from: data)
          self.charachterListApiTotal.value = charachterList.data.total
          self.processFetchedCharachterDetail(charachterList: charachterList) {_ in
            self.isCharachterDataLoading.value = false
            if let response = response {
              debugPrint(response)
            }
          }
        } catch {
          print(error)
          self.errorCharachter.value = error.localizedDescription
        }
      }
      if let error = error {
        print(error)
        self.errorCharachter.value = error.localizedDescription
      }
    }
  }

  private func processFetchedCharachterDetail(charachterList: ResponseJson<ResultCharachter>,
                                              needCache: Bool = true, completionHandler: @escaping ( Bool?) -> Void) {
    if charachterList.data.results.count == 0 {
      self.errorCharachter.value = ResponsListConstant.ErrorMessages.NoDataToShow
      return
    }
        self.charachterList = charachterList.data.results
        self.charachterListApiOffset = self.charachterList.count
        self.noOfCharachters.value = self.charachterList.count
        completionHandler(true)

  }

}
