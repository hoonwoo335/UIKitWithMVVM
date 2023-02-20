//
//  ViewController.swift
//  UIKitWithMVVM
//
//  Created by Jerry Uhm on 2023/02/20.
//

import UIKit
import Combine

class ViewController: UIViewController {
    let screenRect = UIScreen.main.bounds
    var tableView: UITableView = UITableView(frame: CGRect.zero, style: .plain)
    
    var viewModel: ViewModel = ViewModel()
    var tempPosts: [PostModel] = []
    
    var disposeBag = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 130
        
        let tableViewCellNib = UINib(nibName: String(describing: TableViewCell.self), bundle: nil)
        tableView.register(tableViewCellNib, forCellReuseIdentifier: "tableViewCellNib")
        
        // set data binding
        setupBinding()
        
        // request data to viewModel
        viewModel.getPosts()
    }

    func setupBinding() {
        self.viewModel.$posts.sink { posts in
            print("viewModel.posts - ", posts.count)
            self.tempPosts = posts
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.store(in: &disposeBag)
    }

}

//MARK: - UITableViewDelegate 관련 메소드
extension ViewController: UITableViewDelegate {
    
}

//MARK: - UITableViewDataSource 관련 메소드
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tempPosts.count
    }
      
    // setup cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCellNib", for: indexPath) as! TableViewCell
        
        cell.title.text = tempPosts[indexPath.row].title
        cell.desc.text = tempPosts[indexPath.row].body
        
        return cell
        
    }
}

