//
//  ViewController.swift
//  ThumbnailNavigationBar
//
//  Created by Robin Malhotra on 05/10/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {

    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }



    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print((scrollView as? UITableView)?.contentOffset)
    }

}

