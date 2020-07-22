import UIKit
import ModelDataSource

//
// MARK: - CharachterCell
//
final class CharachterCell: UICollectionViewCell, ModelDataSourceViewDisplayable {

    // MARK: ModelDataSourceViewDisplayable

    static var source: Source<CharachterCell> {
        return .nib(UINib(nibName: String(describing: CharachterCell.self), bundle: nil))
    }

  public  var model: ResultCharachter? {
        didSet {
            configureWith()
        }
    }
    //
    // MARK: - Class Constants
    //
    static let identifier = "CharachterCell"

    //
    // MARK: - Outlets
    //

    @IBOutlet weak var imageCard: CustomUIImageView!

    //
    // MARK: - Table View Cell
    //
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCard.image = nil
        imageCard.canceltask()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageCard.contentMode = .scaleAspectFill
    }
    func  selected() {
        imageCard.layer.borderWidth=2.0
        imageCard.layer.borderColor = UIColor.blue.cgColor
    }
    public func configureWith() {

        imageCard.layer.masksToBounds = false
        imageCard.layer.cornerRadius = 40
        imageCard.clipsToBounds = true
        imageCard.layer.borderWidth=1.0
        guard let path = model?.thumbnail.path,
        let pathExtension = model?.thumbnail.thumbnailExtension,
        var url = URL(string: path) else { return }
           url.appendPathExtension(pathExtension)
        imageCard.downloadedFrom(url: url, path: "photo/temp/Charachters/")
    }
}
