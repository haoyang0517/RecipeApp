//
//  RecipeListViewController.swift
//  RecipeApp
//
//  Created by Hao Yang Yip on 21/05/2025.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RecipeListViewController: UIViewController {
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let filterButton = UIButton(type: .system)
    var viewModel: RecipeListViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: RecipeListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchRecipes()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Recipes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))

        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(filterButton)

        searchBar.placeholder = "Search by recipe title"
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview()
            make.right.equalTo(filterButton.snp.left)
        }

        filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
        filterButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchBar)
            make.right.equalToSuperview().inset(8)
            make.width.equalTo(44)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
        }

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecipeCell")
    }

    private func bindViewModel() {
        // Bind search bar
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)

        // Bind recipes to table view
        viewModel.recipes
            .bind(to: tableView.rx.items(cellIdentifier: "RecipeCell")) { _, recipe, cell in
                cell.textLabel?.text = "\(recipe.title) (\(recipe.type))"
            }
            .disposed(by: disposeBag)

        // Handle filter button tap
        filterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                
                // Need guard because using [weak self]
                guard let viewModel = self?.viewModel else {
                    return
                }

                guard let pickerVC = AppDIContainer.shared.container.resolve(RecipeTypePickerViewController.self, argument: viewModel) else {
                    return
                }
                pickerVC.modalPresentationStyle = .overCurrentContext
                pickerVC.modalTransitionStyle = .crossDissolve
                self?.present(pickerVC, animated: true)
            })
            .disposed(by: disposeBag)

        // Handle table view selection
        tableView.rx.modelSelected(RecipeModel.self)
            .subscribe(onNext: { [weak self] recipe in
                let detailVC = AppDIContainer.shared.container.resolve(RecipeDetailViewController.self, argument: recipe)!
                self?.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }

    @objc private func addTapped() {
        let addVC = AppDIContainer.shared.container.resolve(RecipeFormViewController.self)!
        navigationController?.pushViewController(addVC, animated: true)
    }
}
