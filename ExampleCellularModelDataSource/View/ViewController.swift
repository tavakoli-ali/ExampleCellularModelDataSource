//
//  ViewController.swift
//  Examole CellularModelDataSource
//
//  Created by Ali Tavakoli on 20.07.20.
//
import UIKit
import ModelDataSource

final class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView?
    @IBOutlet private weak var collectionView: UICollectionView?

    private var dataSourceTsbleView: TableViewDataSource = TableViewDataSource()
    private var dataSourceCollectionView: CollectionViewDataSource = CollectionViewDataSource()

    private  var viewModelCharachter: CharachterListViewModel?
    private  var viewModelComic: ComicListViewModel?
    private var charachterSelected: Int?

    //    Viewdidload data fetch
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView?.collectionViewLayout = layout

        viewModelCharachter = CharachterListViewModelDetails()
        viewModelComic = ComicListViewModelViewDetails()

        setupViewModel()
        setupDataSource()
    }
    private func setupViewModel() {
        viewModelCharachter?.noOfCharachters.bind {[unowned self] _ in
            DispatchQueue.main.async {
                if  self.charachterSelected==nil {
                  guard let char = self.viewModelCharachter?.getSelectedCharachterViewModel(atIndex: 1) else {return}
                  self.charachterSelected = char.id
                  guard let temp = self.charachterSelected else {return}
                  self.viewModelComic?.fetchComicList(charID: temp)
                }

                         self.buildCollectionView()
            }
        }
        viewModelCharachter?.isCharachterDataLoading.bind { show in
            if show {
            } else {DispatchQueue.main.async {}}
        }
        viewModelCharachter?.errorCharachter.bind {errorMessage in
            debugPrint(errorMessage)
        }
        viewModelCharachter?.fetchCharachterList()

        viewModelComic?.noOfComics.bind {[unowned self] _ in
                DispatchQueue.main.async {
                    self.buildTableView()
              }
            }
             viewModelComic?.isComicDataLoading.bind {[unowned self] show in
                if show {

                } else {
                    DispatchQueue.main.async {
                      self.tableView?.reloadData()

                  }
                }
            }
             viewModelComic?.error.bind {[unowned self] errorMessage in
              DispatchQueue.main.async {
                print(errorMessage + "comic" )
                self.tableView?.reloadData()
//                  let title = "Warning".localizedString
//                  let action = UIAlertAction(title: "OK".localizedString, style: .default)
              }

            }
    }

    private func buildTableView() {
        guard let noOfComics = viewModelComic?.noOfComics.value else {return}
        if noOfComics > 0 {
            for index in 1...noOfComics {
                guard let comicModel = viewModelComic?.getSelectedComicViewModel(atIndex: index) else {return}
                self.dataSourceTsbleView.append(item: .init(model: comicModel, cell: ComicCell.self))}
            tableView?.isHidden = false
            tableView?.reloadData()
        } else {
            dataSourceTsbleView.removeAll()
            tableView?.reloadData()

        }
    }

    private func buildCollectionView() {
        guard let noOfCharachters = viewModelCharachter?.noOfCharachters.value else {return}
        for index in 1...noOfCharachters {
            guard let charachterModel = viewModelCharachter?.getSelectedCharachterViewModel(atIndex: index) else {return}
            self.dataSourceCollectionView.append(item: .init(model: charachterModel, cell: CharachterCell.self))}

        collectionView?.reloadData()
    }

    private func setupDataSource() {
        tableView?.delegate = self
        tableView?.dataSource = dataSourceTsbleView
        tableView?.register(ComicCell.self)

        collectionView?.register(CharachterCell.self)
        collectionView?.delegate = self
        collectionView?.dataSource = dataSourceCollectionView
    }
}

extension ViewController: UITableViewDelegate {

    // MARK: Cells

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  dataSourceTsbleView.heightForCellAtIndexPath(indexPath)
    }

    // MARK: Header

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataSourceTsbleView.heightForDecorativeView(inSection: section, ofKind: .header) ?? UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return dataSourceTsbleView.tableView(tableView, decorativeViewOfKind: .header, inSection: section)
    }
}

extension ViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         guard let tempModel = viewModelCharachter else {return}
        let char = tempModel.getSelectedCharachterViewModel(atIndex: indexPath.row+1)
        self.charachterSelected = char.id
        tableView?.isHidden = true
        viewModelComic?.preLoadComicList()
        guard let temp = self.charachterSelected else {return}
        if charachterSelected == temp {collectionView.reloadData()}
        viewModelComic?.fetchComicList(charID: temp)
      }
}
