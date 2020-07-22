//
//  HeightEstimatable.swift
//  ExamoleCellularModelDataSource
//
//  Created by Ali Tavakoli on 22.07.20.
//

import UIKit
import ModelDataSource

protocol HeightEstimatable {

    /// Estimated height fo the cell
    static var estimatedHeight: CGFloat { get }

}

extension TableViewDataSource {

    func estimatedHeightForCellAtIndexPath(_ index: IndexPath) -> CGFloat? {
        if let type = self[index].cell.self as? HeightEstimatable.Type {
            return type.estimatedHeight
        }
        return nil
    }

}
