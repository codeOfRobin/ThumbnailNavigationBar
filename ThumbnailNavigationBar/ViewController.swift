//
//  ViewController.swift
//  ThumbnailNavigationBar
//
//  Created by Robin Malhotra on 05/10/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // A Tribute
        self.title = "TONavigationBar"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Back", style: .plain, target: nil, action: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: identifier)
            cell?.accessoryType = .disclosureIndicator
        }

        cell?.textLabel?.text = "Tap here for clear bar"
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = SubSubViewController.init(nibName: nil, bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.thumbnailNavigationBar?.setBackgroundHidden(false, animated: animated, for: self)
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print((scrollView as? UITableView)?.contentOffset)
    }

}

