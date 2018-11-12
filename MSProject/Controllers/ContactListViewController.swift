//
//  ContactListViewController.swift
//  MSProject
//
//  Created by KanChen on 11/9/18.
//  Copyright © 2018 drchrono. All rights reserved.
//

import UIKit

private let contactDetailCellIdentifier = "contactDetailCellIdentifier"
private let contactAvatarCellIdentifier = "contactAvatarCellIdentifier"

class ContactListViewController: UIViewController {
    private var contactCollectionView: UICollectionView!
    private var contactTableView: UITableView!
    private var viewModel = ContactListViewModel()

    override func loadView() {
        let view = UIView(frame: .zero)
        view.backgroundColor = .red
        contactCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        contactCollectionView.backgroundColor = .white
        view.addSubview(contactCollectionView)
        contactCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(
            NSLayoutConstraint
                .constraints(withVisualFormat: "H:|[collectionView]|",
                             options: [],
                             metrics: nil,
                             views: ["collectionView": contactCollectionView])
        )
        view.addConstraints(
            NSLayoutConstraint
                .constraints(withVisualFormat: "V:|[collectionView(120)]",
                             options: [],
                             metrics: nil,
                             views: ["collectionView": contactCollectionView])
        )

        contactTableView = UITableView(frame: .zero, style: .plain)
        view.addSubview(contactTableView)
        contactTableView.translatesAutoresizingMaskIntoConstraints = false

        view.addConstraints(
            NSLayoutConstraint
                .constraints(withVisualFormat: "H:|[tableView]|",
                             options: [],
                             metrics: nil,
                             views: ["tableView": contactTableView])
        )
        view.addConstraints(
            NSLayoutConstraint
                .constraints(withVisualFormat: "V:[collectionView][tableView]|",
                             options: [],
                             metrics: nil,
                             views: ["tableView": contactTableView,
                                     "collectionView": contactCollectionView])
        )

        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contact"
        contactTableView.dataSource = self
        contactTableView.delegate = self
        contactTableView.register(ContactDetailCell.self, forCellReuseIdentifier: contactDetailCellIdentifier)
        contactTableView.allowsSelection = false
        contactCollectionView.dataSource = self
        contactCollectionView.delegate = self
        contactCollectionView.register(ContactAvatarCell.self, forCellWithReuseIdentifier: contactAvatarCellIdentifier)
        (contactCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        do {
            try viewModel.loadData()
        } catch {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

extension ContactListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: contactDetailCellIdentifier, for: indexPath) as! ContactDetailCell
        cell.configure(with: viewModel.contacts[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
}

extension ContactListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.contacts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contactAvatarCellIdentifier, for: indexPath) as! ContactAvatarCell
        cell.configure(with: viewModel.contacts[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 74, height: 74)
    }
}
