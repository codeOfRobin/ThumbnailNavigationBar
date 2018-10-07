//
//  SubSubViewController.swift
//  ThumbnailNavigationBar
//
//  Created by Robin Malhotra on 07/10/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import UIKit

class SubSubViewController: UITableViewController {

    var headerView: ThumbnailHeaderImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Firewatch"
        self.navigationItem.largeTitleDisplayMode = .never
        self.tableView.contentInsetAdjustmentBehavior = .never

        self.headerView = ThumbnailHeaderImageView(image: UIImage(named: "Firewatch")!, height: 200)
        self.headerView?.shadowHidden = false
        self.tableView.tableHeaderView = self.headerView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.thumbnailNavigationBar?.setBackgroundHidden(true, animated: animated, for: self)
        self.navigationController?.thumbnailNavigationBar?.setTargetScrollView(self.tableView, minimumOffset: 200)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell?.accessoryType = .disclosureIndicator
        }

        cell?.textLabel?.text = "Tap here for normal bar"
        return cell!
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.headerView?.scrollOffset = scrollView.contentOffset.y
    }

}
