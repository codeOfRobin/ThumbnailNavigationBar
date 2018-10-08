//
//  TextureExampleViewController.swift
//  ThumbnailNavigationBar
//
//  Created by Robin Malhotra on 08/10/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import AsyncDisplayKit

class TextureExampleViewController: UIViewController, ASTableDelegate, ASTableDataSource {

    let tableNode = ASTableNode()
    let redNode = RedNode()

    static let thumbnailURL = URL(string: "https://storage.googleapis.com/scott_test_bucket/readyp1080.jpg")
    let header: ThumbnailHeaderImageView
    let headerImage = ASNetworkImageNode()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.header = ThumbnailHeaderImageView(embeddedView: headerImage.view, height: 200)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubnode(tableNode)

        self.title = "Firewatch"
        self.navigationItem.largeTitleDisplayMode = .never
        self.tableNode.view.contentInsetAdjustmentBehavior = .never

        headerImage.url = TextureExampleViewController.thumbnailURL!
        self.tableNode.view.tableHeaderView = header
        self.tableNode.dataSource = self
        self.tableNode.delegate = self

        // Do any additional setup after loading the view.
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.header.scrollOffset = scrollView.contentOffset.y
    }

    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let node =  RedNode()
        node.backgroundColor = .green
        return node
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.thumbnailNavigationBar?.setBackgroundHidden(true, animated: animated, for: self)
        self.navigationController?.thumbnailNavigationBar?.setTargetScrollView(self.tableNode.view, minimumOffset: 200)
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableNode.frame = self.view.bounds
    }

}
