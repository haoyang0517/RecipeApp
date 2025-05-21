//
//  RecipeDetailViewController.swift
//  RecipeApp
//
//  Created by Hao Yang Yip on 21/05/2025.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RecipeDetailViewController: UIViewController {
    private let titleSectionLabel = UILabel()
    private let titleField = UITextField()
    private let imageSectionLabel = UILabel()
    private let imageView = UIImageView()
    private let imageButton = UIButton(type: .system)
    private let typeSectionLabel = UILabel()
    private let typeLabel = UILabel()
    private let ingredientsSectionLabel = UILabel()
    private let ingredientsField = UITextView()
    private let stepsSectionLabel = UILabel()
    private let stepsField = UITextView()
    private let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: nil)
    private let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: nil, action: nil)
    var viewModel: RecipeDetailViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
        bindViewModel()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        // Title Section
        titleSectionLabel.text = "Title:"
        titleSectionLabel.font = .systemFont(ofSize: 16, weight: .bold)
        view.addSubview(titleSectionLabel)
        titleSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }

        titleField.borderStyle = .roundedRect
        titleField.isEnabled = false
        view.addSubview(titleField)
        titleField.snp.makeConstraints { make in
            make.top.equalTo(titleSectionLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
        }

        // Image Section
        imageSectionLabel.text = "Image:"
        imageSectionLabel.font = .systemFont(ofSize: 16, weight: .bold)
        view.addSubview(imageSectionLabel)
        imageSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleField.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }

        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(imageSectionLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }

        imageButton.setTitle("Change Image", for: .normal)
        imageButton.isEnabled = false
        view.addSubview(imageButton)
        imageButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }

        // Type Section
        typeSectionLabel.text = "Type:"
        typeSectionLabel.font = .systemFont(ofSize: 16, weight: .bold)
        view.addSubview(typeSectionLabel)
        typeSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(imageButton.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }

        typeLabel.font = .systemFont(ofSize: 16, weight: .regular)
        view.addSubview(typeLabel)
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(typeSectionLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
        }

        // Ingredients Section
        ingredientsSectionLabel.text = "Ingredients:"
        ingredientsSectionLabel.font = .systemFont(ofSize: 16, weight: .bold)
        view.addSubview(ingredientsSectionLabel)
        ingredientsSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }

        ingredientsField.layer.borderWidth = 1
        ingredientsField.layer.borderColor = UIColor.systemGray.cgColor
        ingredientsField.isEditable = false
        view.addSubview(ingredientsField)
        ingredientsField.snp.makeConstraints { make in
            make.top.equalTo(ingredientsSectionLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }

        // Steps Section
        stepsSectionLabel.text = "Steps:"
        stepsSectionLabel.font = .systemFont(ofSize: 16, weight: .bold)
        view.addSubview(stepsSectionLabel)
        stepsSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(ingredientsField.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }

        stepsField.layer.borderWidth = 1
        stepsField.layer.borderColor = UIColor.systemGray.cgColor
        stepsField.isEditable = false
        view.addSubview(stepsField)
        stepsField.snp.makeConstraints { make in
            make.top.equalTo(stepsSectionLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(100)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }

    private func setupNavigation() {
        navigationItem.rightBarButtonItems = [editButton, deleteButton]
    }


    private func bindViewModel() {
        viewModel.title
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)

        viewModel.title
            .bind(to: titleField.rx.text)
            .disposed(by: disposeBag)

        viewModel.type
            .bind(to: typeLabel.rx.text)
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

        ingredientsField.rx.text.orEmpty
            .bind(to: viewModel.ingredients)
            .disposed(by: disposeBag)

        stepsField.rx.text.orEmpty
            .bind(to: viewModel.steps)
            .disposed(by: disposeBag)

        // Handle edit mode
        viewModel.isEditing
            .bind(onNext: { [weak self] isEditing in
                self?.titleField.isEnabled = isEditing
                self?.imageButton.isEnabled = isEditing
                self?.ingredientsField.isEditable = isEditing
                self?.stepsField.isEditable = isEditing
                self?.editButton.title = isEditing ? "Save" : "Edit"
                self?.editButton.style = isEditing ? .done : .plain
            })
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

        // Handle edit/save button
        editButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if self?.viewModel.isEditing.value == true {
                    Task {
                        do {
                            try await self?.viewModel.saveRecipe()
                            self?.viewModel.isEditing.accept(false)
                        } catch {
                            print("Error saving recipe: \(error)")
                        }
                    }
                } else {
                    self?.viewModel.isEditing.accept(true)
                }
            })
            .disposed(by: disposeBag)

        // Handle delete button
        deleteButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let alert = UIAlertController(title: "Delete Recipe", message: "Are you sure you want to delete this recipe?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
                    Task {
                        do {
                            try await self?.viewModel.deleteRecipe()
                            self?.navigationController?.popViewController(animated: true)
                        } catch {
                            print("Error deleting recipe: \(error)")
                        }
                    }
                })
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)

    }
    
    @objc private func deleteTapped() {
        let alert = UIAlertController(title: "Delete Recipe", message: "Are you sure you want to delete this recipe?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            Task {
                do {
                    try await self?.viewModel.deleteRecipe()
                    self?.navigationController?.popViewController(animated: true)
                } catch {
                    print("Error deleting recipe: \(error)")
                }
            }
        })
        present(alert, animated: true)
    }

}

extension RecipeDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            viewModel.image.accept(image)
        }
        dismiss(animated: true)
    }
}
