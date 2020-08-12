//
//  ScrollViewManager.swift
//  AudioBase
//
//  Created by James Koch on 8/4/20.
//  Copyright © 2020 James Koch. All rights reserved.
//

import SwiftUI
import UIKit

extension UIView {
    
    func superview<T>(of type: T.Type) -> T? {
        if let result = superview as? T {
            if let scrollView = result as? UIScrollView {
                if scrollView.frame.height < 40 {
                    return superview?.superview(of: type)
                }
            }
            return result
        } else {
            return superview?.superview(of: type)
        }
    }
}

struct TableViewFinder: UIViewRepresentable {
    
    let scrollManager: ScrollManager
    
    func makeUIView(context: Context) -> ChildViewOfTableView {
        let view = ChildViewOfTableView()
        view.scrollManager = scrollManager
        
        return view
    }
    
    func updateUIView(_ uiView: ChildViewOfTableView, context: Context) {}
}

class ChildViewOfTableView: UIView {
    
    weak var scrollManager: ScrollManager?
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if scrollManager?.tableView == nil {
            scrollManager?.tableView = self.superview(of: UITableView.self)
        }
    }
}

class ScrollManager {
    weak var tableView: UITableView?
    
    func scrollTo(_ indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            guard let tableView = self?.tableView else { return }
            if tableView.numberOfSections > indexPath.section && tableView.numberOfRows(inSection: indexPath.section) > indexPath.row {
                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }

    }
}

struct ScrollManagerView: UIViewRepresentable {
    let scrollManager: ScrollManager
    
    @Binding var indexPathToSetVisible: IndexPath?
    
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let indexPath = indexPathToSetVisible else { return }
        
        // the scrolling has to be inside this method, because it gets called after the table view was already updated with the new row
        scrollManager.scrollTo(indexPath)
        
        DispatchQueue.main.async {
            self.indexPathToSetVisible = nil
        }
    }
    
}
