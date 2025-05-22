//
//  RecipeTypePickerViewController.swift
//  RecipeApp
//
//  Created by Hao Yang Yip on 22/05/2025.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RecipeTypePickerViewController: UIViewController {
    private let containerView = UIView()
    private let pickerView = UIPickerView()
    private let selectButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let viewModel: RecipeListViewModel
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
        setupBackgroundTapDismissal()
    }

    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        view.addSubview(containerView)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        containerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }

        containerView.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(32)
            make.height.equalTo(150)
        }

        selectButton.setTitle("Select", for: .normal)
        selectButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        containerView.addSubview(selectButton)
        selectButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.equalTo(pickerView.snp.top).offset(-8)
            make.right.equalToSuperview().inset(16)
        }

        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        containerView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.equalTo(pickerView.snp.top).offset(-8)
            make.left.equalToSuperview().inset(16)
        }
    }

    private func bindViewModel() {
        // Bind pickerView
        viewModel.recipeTypes
            .bind(to: pickerView.rx.itemTitles) { _, item in item }
            .disposed(by: disposeBag)

        // Handle pickerView selection
        viewModel.selectedType
            .take(1)
            .subscribe(onNext: { [weak self] selectedType in
                guard let self = self else { return }
                let types = self.viewModel.recipeTypes.value
                if let type = selectedType, let index = types.firstIndex(of: type) {
                    self.pickerView.selectRow(index, inComponent: 0, animated: false)
                } else if !types.isEmpty {
                    self.pickerView.selectRow(0, inComponent: 0, animated: false)
                }
            })
            .disposed(by: disposeBag)

        // Handle select button
        selectButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let selectedRow = self.pickerView.selectedRow(inComponent: 0)
                let types = self.viewModel.recipeTypes.value
                if !types.isEmpty, selectedRow < types.count {
                    let selectedType = types[selectedRow]
                    self.viewModel.selectedType.accept(selectedType)
                }
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        // Handle cancel button
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupBackgroundTapDismissal() {
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] gesture in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
