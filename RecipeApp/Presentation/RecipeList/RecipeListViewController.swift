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
    private let tableView = UITableView()
    private let pickerView = UIPickerView()
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

        view.addSubview(tableView)
        view.addSubview(pickerView)
        view.addSubview(filterButton)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(pickerView.snp.top)
        }
        pickerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(150)
        }
        filterButton.setTitle("Filter by Type", for: .normal)
        filterButton.snp.makeConstraints { make in
            make.bottom.equalTo(pickerView.snp.top).offset(-8)
            make.centerX.equalToSuperview()
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecipeCell")
    }

    private func bindViewModel() {
        
        viewModel.recipeTypes
            .bind(to: pickerView.rx.itemTitles) { _, item in item }
            .disposed(by: disposeBag)

        pickerView.rx.modelSelected(String.self)
            .map { $0.first }
            .bind(to: viewModel.selectedType)
            .disposed(by: disposeBag)

        viewModel.recipes
            .bind(to: tableView.rx.items(cellIdentifier: "RecipeCell")) { _, recipe, cell in
                cell.textLabel?.text = "\(recipe.title) (\(recipe.type))"
            }
            .disposed(by: disposeBag)

        filterButton.rx.tap
            .withLatestFrom(pickerView.rx.modelSelected(String.self))
            .map { $0.first }
            .bind(to: viewModel.selectedType)
            .disposed(by: disposeBag)
        
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
