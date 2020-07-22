//
//  ComicCell.swift
//  ExamoleCellularModelDataSource
//
//  Created by Ali Tavakoli on 22.07.20.
//

import UIKit
import ModelDataSource

//
// MARK: - Session Cell
//
final class ComicCell: UITableViewCell, ModelDataSourceViewDisplayable {

      // MARK: ModelDataSourceViewDisplayable

    static var source: Source<ComicCell> {
          return .nib(UINib(nibName: String(describing: ComicCell.self), bundle: nil))
      }

    public  var model: ResultComic? {
          didSet {
              configureWith()
          }
      }

  //
  // MARK: - Class Constants
  //
  @IBOutlet weak var container: UIView!
  static let identifier = "ComicCell"

  //
  // MARK: - Outlets
  //
  @IBOutlet weak var descLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var imageCard: CustomUIImageView!
  @IBOutlet weak var imageCharachter: CustomUIImageView!

  override func layoutSubviews() {
     super.layoutSubviews()
     imageCharachter.layer.borderWidth=1.0
     imageCharachter.layer.masksToBounds = false
     imageCharachter.layer.borderColor = UIColor.white.cgColor
     imageCharachter.layer.cornerRadius = 25
     imageCharachter.clipsToBounds = true
     imageCard.contentMode = .scaleAspectFit
     imageCharachter.contentMode = .scaleAspectFill

  }

  //
  // MARK: - Table View Cell
  //
  override func prepareForReuse() {
    super.prepareForReuse()
 //   configureWith( .none)
    descLabel.text = nil
    dateLabel.text = nil
    titleLabel.text = nil
    imageCard.image = nil
    imageCharachter.image = nil
    imageCard.canceltask()
    imageCharachter.canceltask()
  }

    private func configureWith() {

        guard let path = model?.thumbnail?.path,
            let pathExtension = model?.thumbnail?.thumbnailExtension,
           var url = URL(string: path) else { return }
              url.appendPathExtension(pathExtension)
        imageCard.downloadedFrom(url: url, path: "photo/temp/Comics/\(model?.id ?? 1)/")
        imageCharachter.downloadedFrom(url: url, path: "photo/temp/Charachters/")

        titleLabel.text = model?.title
//        swiftlint:disable:next no_date_instantiation
        guard  let text = model?.dates?[0].date else {return}
        dateLabel.text = text
        descLabel.text = model?.resultDescription
        guard let readmoreFont = UIFont(name: "Helvetica-Oblique", size: 14.0)  else {return}
        guard let readmoreFontColor = UIColor(named: "rw-highlight") else {return}
        DispatchQueue.main.async {
          self.descLabel.addTrailing(with: "... ", moreText: "Readmore", moreTextFont: readmoreFont, moreTextColor: readmoreFontColor)
        }
    }
}
