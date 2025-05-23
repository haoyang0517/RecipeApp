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
    private let scrollView = UIScrollView()
    private let contentView = UIView()
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
    private var editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: nil)
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
        titleField.isEnabled = false
        contentView.addSubview(titleField)
        titleField.snp.makeConstraints { make in
            make.top.equalTo(titleSectionLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
        }

        // Image Section
        imageSectionLabel.text = "Image:"
        imageSectionLabel.font = .systemFont(ofSize: 16, weight: .bold)
        contentView.addSubview(imageSectionLabel)
        imageSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleField.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        imageButton.isHidden = true
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(imageSectionLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }

        imageButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        imageButton.tintColor = .white
        imageButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        contentView.addSubview(imageButton)
        imageButton.snp.makeConstraints { make in
            make.edges.equalTo(imageView)
        }

        // Type Section
        typeSectionLabel.text = "Type:"
        typeSectionLabel.font = .systemFont(ofSize: 16, weight: .bold)
        contentView.addSubview(typeSectionLabel)
        typeSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }

        typeLabel.font = .systemFont(ofSize: 16, weight: .regular)
        contentView.addSubview(typeLabel)
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(typeSectionLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
        }

        // Ingredients Section
        ingredientsSectionLabel.text = "Ingredients:"
        ingredientsSectionLabel.font = .systemFont(ofSize: 16, weight: .bold)
        contentView.addSubview(ingredientsSectionLabel)
        ingredientsSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }

        ingredientsField.layer.borderWidth = 1
        ingredientsField.layer.borderColor = UIColor.systemGray.cgColor
        ingredientsField.isEditable = false
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
        stepsField.isEditable = false
        contentView.addSubview(stepsField)
        stepsField.snp.makeConstraints { make in
            make.top.equalTo(stepsSectionLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(100)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    private func setupNavigation() {
        navigationItem.rightBarButtonItems = [editButton, deleteButton]
        self.bindEditButton()
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
                self?.imageButton.isHidden = !isEditing
                
                // Toggle editable states
                self?.ingredientsField.isEditable = isEditing
                self?.ingredientsField.isSelectable = isEditing
                self?.stepsField.isEditable = isEditing
                self?.stepsField.isSelectable = isEditing

                // Apply matching visual styles
                let backgroundColor = isEditing ? UIColor.systemBackground : UIColor.systemGray6

                [self?.ingredientsField, self?.stepsField].forEach { textView in
                    textView?.backgroundColor = backgroundColor
                    textView?.layer.borderWidth = 0.5
                    textView?.layer.borderColor = UIColor.separator.cgColor
                    textView?.layer.cornerRadius = 5
                }
                let newButton = UIBarButtonItem(
                    title: isEditing ? "Save" : "Edit",
                    style: isEditing ? .done : .plain,
                    target: self,
                    action: nil
                )
                self?.editButton = newButton
                self?.setupNavigation()
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
    
    func bindEditButton() {
        // Handle edit/save button
        editButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if self?.viewModel.isEditing.value == true {
                    Task {
                        do {
                            try await self?.viewModel.saveRecipe()
                            self?.viewModel.isEditing.accept(false)
                        } catch {
                            let alert = UIAlertController(title: "Save Failure", message: error.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            self?.present(alert, animated: true)
                        }
                    }
                } else {
                    self?.viewModel.isEditing.accept(true)
                }
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
