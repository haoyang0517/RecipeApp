//
//  RecipeFormViewController.swift
//  RecipeApp
//
//  Created by Hao Yang Yip on 21/05/2025.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RecipeFormViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleSectionLabel = UILabel()
    private let titleField = UITextField()
    private let typeSectionLabel = UILabel()
    private let pickerView = UIPickerView()
    private let imageSectionLabel = UILabel()
    private let imageView = UIImageView()
    private let imageButton = UIButton(type: .system)
    private let ingredientsSectionLabel = UILabel()
    private let ingredientsField = UITextView()
    private let stepsSectionLabel = UILabel()
    private let stepsField = UITextView()
    private let saveButton = UIButton(type: .system)
    var viewModel: RecipeFormViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Add Recipe"

        // Setup ScrollView
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // Setup ContentView
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }

        // Title Section
        titleSectionLabel.text = "Title:"
        titleSectionLabel.font = .systemFont(ofSize: 16, weight: .bold)
        contentView.addSubview(titleSectionLabel)
        titleSectionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
        }

        titleField.borderStyle = .roundedRect
        titleField.placeholder = "Enter recipe title"
        contentView.addSubview(titleField)
        titleField.snp.makeConstraints { make in
            make.top.equalTo(titleSectionLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
        }

        // Type Section
        typeSectionLabel.text = "Type:"
        typeSectionLabel.font = .systemFont(ofSize: 16, weight: .bold)
        contentView.addSubview(typeSectionLabel)
        typeSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleField.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }

        contentView.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(typeSectionLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview()
            make.height.equalTo(150)
        }

        // Image Section
        imageSectionLabel.text = "Image:"
        imageSectionLabel.font = .systemFont(ofSize: 16, weight: .bold)
        contentView.addSubview(imageSectionLabel)
        imageSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(pickerView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }

        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(imageSectionLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }

        imageButton.setTitle("Select Image", for: .normal)
        contentView.addSubview(imageButton)
        imageButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }

        // Ingredients Section
        ingredientsSectionLabel.text = "Ingredients:"
        ingredientsSectionLabel.font = .systemFont(ofSize: 16, weight: .bold)
        contentView.addSubview(ingredientsSectionLabel)
        ingredientsSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(imageButton.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }

        ingredientsField.layer.borderWidth = 1
        ingredientsField.layer.borderColor = UIColor.systemGray.cgColor
        ingredientsField.text = "Enter ingredients, one per line"
        contentView.addSubview(ingredientsField)
        ingredientsField.snp.makeConstraints { make in
            make.top.equalTo(ingredientsSectionLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }

        // Steps Section
        stepsSectionLabel.text = "Steps:"
        stepsSectionLabel.font = .systemFont(ofSize: 16, weight: .bold)
        contentView.addSubview(stepsSectionLabel)
        stepsSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(ingredientsField.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }

        stepsField.layer.borderWidth = 1
        stepsField.layer.borderColor = UIColor.systemGray.cgColor
        stepsField.text = "Enter steps, one per line"
        contentView.addSubview(stepsField)
        stepsField.snp.makeConstraints { make in
            make.top.equalTo(stepsSectionLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }

        // Save Button
        saveButton.setTitle("Save Recipe", for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        contentView.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(stepsField.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16) 
        }
    }
    
    private func bindViewModel() {
        // Bind view model to UI
        viewModel.recipeTypes
            .bind(to: pickerView.rx.itemTitles) { _, item in item }
            .disposed(by: disposeBag)

        viewModel.title
            .bind(to: titleField.rx.text)
            .disposed(by: disposeBag)

        viewModel.image
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)

        viewModel.ingredients
            .bind(to: ingredientsField.rx.text)
            .disposed(by: disposeBag)

        viewModel.steps
            .bind(to: stepsField.rx.text)
            .disposed(by: disposeBag)

        // Bind UI to view model
        titleField.rx.text.orEmpty
            .bind(to: viewModel.title)
            .disposed(by: disposeBag)

        pickerView.rx.modelSelected(String.self)
            .map { $0.first }
            .bind(to: viewModel.selectedType)
            .disposed(by: disposeBag)

        ingredientsField.rx.text.orEmpty
            .bind(to: viewModel.ingredients)
            .disposed(by: disposeBag)

        stepsField.rx.text.orEmpty
            .bind(to: viewModel.steps)
            .disposed(by: disposeBag)

        // Handle image picker
        imageButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .photoLibrary
                self?.present(picker, animated: true)
            })
            .disposed(by: disposeBag)

        // Handle save
        saveButton.rx.tap
            .subscribe(onNext: { [weak self] in
                Task {
                    do {
                        try await self?.viewModel.saveRecipe()
                        self?.navigationController?.popViewController(animated: true)
                    } catch {
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(alert, animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

extension RecipeFormViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.recipeTypes.value.count
    }
}

extension RecipeFormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            viewModel.image.accept(image)
        }
        dismiss(animated: true)
    }
}
