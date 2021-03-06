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
        self.frame = CGRect.init(x: 0, y: 0, width: 200, height: 200)
    }

    override func calculateLayoutThatFits(_ constrainedSize: ASSizeRange) -> ASLayout {
        return ASLayout(layoutElement: self, size: CGSize.init(width: 200, height: 200))
    }
}

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

        headerImage.image = UIImage(named: "Firewatch")
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
		switch indexPath.row % 3 {
		case 0:
			node.backgroundColor = .cyan
		case 1:
			node.backgroundColor = .orange
		case 2:
			node.backgroundColor = .purple
		default:
			break
		}
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
