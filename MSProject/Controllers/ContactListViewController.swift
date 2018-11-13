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
private let avatarCellWidth: CGFloat = 84.0

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

    private var placeHolderViewSize: CGSize {
        return CGSize(width: (contactCollectionView.frame.width - avatarCellWidth)/2, height: avatarCellWidth)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        contactTableView.dataSource = self
        contactTableView.delegate = self
        contactTableView.register(ContactDetailCell.self, forCellReuseIdentifier: contactDetailCellIdentifier)
        contactTableView.allowsSelection = false
        contactTableView.separatorStyle = .none

        contactCollectionView.dataSource = self
        contactCollectionView.delegate = self
        contactCollectionView.register(ContactAvatarCell.self, forCellWithReuseIdentifier: contactAvatarCellIdentifier)
        contactCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        contactCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        (contactCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        contactCollectionView.showsHorizontalScrollIndicator = false
        do {
            try viewModel.loadData()
        } catch {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        contactCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition())
    }

    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == contactTableView && tableViewMoveBeginPosition != nil {
            let factor = (scrollView.contentOffset.y / (CGFloat(viewModel.contacts.count) * contactTableView.frame.height))
            let collectionViewRealContentWidth = CGFloat(viewModel.contacts.count) * avatarCellWidth
            contactCollectionView.contentOffset.x = collectionViewRealContentWidth * factor

            if let selectedIndexPath = contactCollectionView.indexPathsForSelectedItems?.first {
                let currentIndex = contactCollectionView.contentOffset.x / avatarCellWidth
                let offset = currentIndex - CGFloat(selectedIndexPath.item)
                if abs(offset) > 0.5 {
                    let target = Int(currentIndex.rounded())
                    contactCollectionView.selectItem(at: IndexPath(item: target, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition())
                }
            }
        } else if scrollView == contactCollectionView && collectionViewMoveBeginPosition != nil {
            let factor = scrollView.contentOffset.x / (CGFloat(viewModel.contacts.count) * avatarCellWidth)
            let tableViewRealContentHeight = CGFloat(viewModel.contacts.count) * contactTableView.frame.height
            contactTableView.contentOffset.y = tableViewRealContentHeight * factor

            // change selected cell if needed
            if scrollView.isDragging || scrollView.isDecelerating,
                let selectedIndexPath = contactCollectionView.indexPathsForSelectedItems?.first {
                let currentIndex = contactCollectionView.contentOffset.x / avatarCellWidth
                let offset = currentIndex - CGFloat(selectedIndexPath.item)
                if abs(offset) > 0.5 {
                    let target = Int(currentIndex.rounded())
                    contactCollectionView.selectItem(at: IndexPath(item: target, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition())
                }
            }
        }
    }

    private var collectionViewMoveBeginPosition: CGPoint?
    private var tableViewMoveBeginPosition: CGPoint?
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        collectionViewMoveBeginPosition = nil
        tableViewMoveBeginPosition = nil
        if scrollView == contactCollectionView {
            collectionViewMoveBeginPosition = scrollView.contentOffset
        } else if scrollView == contactTableView {
            tableViewMoveBeginPosition = scrollView.contentOffset
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == contactTableView {
            guard let beginOffset = tableViewMoveBeginPosition else {
                fatalError()
            }
            if velocity.y == 0 {
                let offset = scrollView.contentOffset.y - beginOffset.y
                var target: Int
                if offset > 50.0 { // forward
                    target = Int((scrollView.contentOffset.y/contactTableView.frame.height).rounded(.up))
                    target = target < viewModel.contacts.count ? target : viewModel.contacts.count - 1
                } else if offset < -50.0 { //backward
                    target = Int(scrollView.contentOffset.y/contactTableView.frame.height)
                    target = target >= 0 ? target : 0
                } else {
                    target = Int(((scrollView.contentOffset.y)/contactTableView.frame.height).rounded())
                }
                contactTableView.scrollToRow(at: IndexPath(row: target, section: 0), at: .top, animated: true)
            } else {
                var target: Int
                if velocity.y > 0 {
                    target = Int((scrollView.contentOffset.y/contactTableView.frame.height).rounded(.up))
                    target = target < viewModel.contacts.count ? target : viewModel.contacts.count - 1
                } else {
                    target = Int(scrollView.contentOffset.y/contactTableView.frame.height)
                    target = target >= 0 ? target : 0
                }
                targetContentOffset.pointee.y = CGFloat(target) * contactTableView.frame.height
            }
        } else if scrollView == contactCollectionView {
            guard let beginOffset = collectionViewMoveBeginPosition else {
                fatalError()
            }
            let endOffset = targetContentOffset.pointee.x
            let endIndex = Int(endOffset/avatarCellWidth)
            let forward = beginOffset.x < scrollView.contentOffset.x
            let stopIndex = forward && (endIndex + 1 < viewModel.contacts.count) ? endIndex + 1 : endIndex
            targetContentOffset.pointee.x = CGFloat(stopIndex) * avatarCellWidth
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

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            return contactCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
        } else if kind == UICollectionView.elementKindSectionHeader {
            return contactCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        }
        fatalError()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionViewMoveBeginPosition = collectionView.contentOffset
        tableViewMoveBeginPosition = nil
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: avatarCellWidth, height: avatarCellWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return self.placeHolderViewSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return self.placeHolderViewSize
    }
}
