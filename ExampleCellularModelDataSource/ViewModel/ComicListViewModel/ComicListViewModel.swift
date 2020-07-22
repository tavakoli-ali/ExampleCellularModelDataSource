import Foundation

protocol ComicListViewModel {
    var isOffline: Dynamic<Bool> { get }
    var noOfComics: Dynamic<Int> { get }
    var comicListApiTotal: Dynamic<Int> { get }
    var isComicDataLoading: Dynamic<Bool> { get }
    var error: Dynamic<String> { get }

  func getSelectedComicViewModel(atIndex indexpath: Int) -> ResultComic

    func fetchComicList(charID: Int)
    func fetchMoreComics()
    func refreshComicList()
    func preLoadComicList()

}
