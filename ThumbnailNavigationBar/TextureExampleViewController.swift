//
//  TextureExampleViewController.swift
//  ThumbnailNavigationBar
//
//  Created by Robin Malhotra on 08/10/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import AsyncDisplayKit

class RedNode: ASCellNode {
    override init() {
        super.init()
        self.backgroundColor = .red
//        self.style.height = ASDimensionMake(200)
//        self.style.width = ASDimensionMake(200)
    }

    override func layout() {
        print(self.bounds)
        self.frame = CGRect.init(x: 0, y: 0, width: 200, height: 200)
    }

    override func calculateLayoutThatFits(_ constrainedSize: ASSizeRange) -> ASLayout {
        return ASLayout(layoutElement: self, size: CGSize.init(width: 200, height: 200))
    }
}

class TextureExampleViewController: UIViewController, ASTableDelegate, ASTableDataSource {

    let tableNode = ASTableNode()
    let redNode = RedNode()

    static let thumbnailURL = URL(string: "https://httpbin.org/image/png")
    let header2 = CoolHeaderWithButton.init(url: TextureExampleViewController.thumbnailURL!, height: 200)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubnode(tableNode)

        self.title = "Firewatch"
        self.navigationItem.largeTitleDisplayMode = .never
        self.tableNode.view.contentInsetAdjustmentBehavior = .never

        self.tableNode.view.tableHeaderView = header2.view
        self.tableNode.dataSource = self
        self.tableNode.delegate = self

        // Do any additional setup after loading the view.
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.header2.respondToScrollOffset(scrollView.contentOffset.y)
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


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableNode.frame = self.view.bounds
    }

}
