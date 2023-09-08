//
//  PaymentProvidersUIView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 7.9.2023.
//

import Foundation
import UIKit

public class PaymentProvidersUIView: UIView {
    typealias ProviderWithImage = (PaymentMethodProvider, UIImage)
    
    private let paymentApis = PaytrailPaymentAPIs()
    let themes: PaytrailThemes = .init(viewMode: .normal())
    private var providerImages: [UIImage] = []
    
    private var providerWithImages: [ProviderWithImage] = []

    public var providers: [PaymentMethodProvider]
    public var groups: [PaymentMethodGroup]
    var currentPaymentRequest: URLRequest?
    
    private var tableView: UITableView = UITableView()
    private var contentFrame: CGRect
    
    private var collectionView: UICollectionView!
    
    public init(frame: CGRect, providers: [PaymentMethodProvider], groups: [PaymentMethodGroup]) {
        
        self.providers = providers
        self.groups = groups
        self.contentFrame = frame
        super.init(frame: frame)

        for provider in providers {
            paymentApis.renderPaymentProviderImage(by: provider.icon ?? "") { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let success):
                    DispatchQueue.main.async {
                        self.providerWithImages.append((provider, success))
                        self.tableView.reloadData()
                        self.collectionView.reloadData()
                    }
                   
                case .failure(let failure):
                    PTLogger.log(message: "Render image failure: \(failure.localizedDescription)", level: .warning)
                    DispatchQueue.main.async {
                        let placeHolder = UIImage(systemName: "exclamationmark.square") ?? UIImage()
                        self.providerWithImages.append((provider, placeHolder))
                        self.tableView.reloadData()
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        
//        tableView = UITableView(frame: contentFrame)
//        tableView.layer.backgroundColor = UIColor.blue.cgColor
//        tableView.separatorStyle = .none
//        self.addSubview(tableView)
//
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(ProviderCell.self, forCellReuseIdentifier: "providerCell")
        
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.itemSize = CGSize(width: 100, height: 100)
//        flowLayout.scrollDirection = .vertical
        let gridLayout = GridFlowLayout()
        gridLayout.headerReferenceSize = CGSize(width: contentFrame.width, height: 50)
        collectionView = UICollectionView(frame: contentFrame, collectionViewLayout: gridLayout)

        self.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProviderCollectionCell.self, forCellWithReuseIdentifier: "providerCell")
        collectionView.register(ProviderHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "providerHeaderView")

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PaymentProvidersUIView: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = providers.filter { $0.group == groups[section].id }
        return rows.count
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        groups.count
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        header.text = groups[section].name
        return header
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "providerCell", for: indexPath) as! ProviderCell
        if providerWithImages.count == providers.count {
            let providerSet = providerWithImages.filter { $0.0.group == groups[indexPath.section].id }
            if cell.providerImageView == nil {
            }
            cell.providerImageView = UIImageView(image: providerSet[indexPath.row].1)

        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension PaymentProvidersUIView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let rows = providers.filter { $0.group == groups[section].id }
        return rows.count
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        groups.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        groups[section].name
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "providerHeaderView", for: indexPath) as! ProviderHeaderView
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 60))
        label.text = groups[indexPath.section].name
        headerView.headerLabel = label
        return headerView
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "providerCell", for: indexPath) as! ProviderCollectionCell
        if providerWithImages.count == providers.count {
            let providerSet = providerWithImages.filter { $0.0.group == groups[indexPath.section].id }

            cell.providerImageView = UIImageView(image: providerSet[indexPath.row].1)
            cell.providerImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 80)
            cell.providerImageView.contentMode = .scaleAspectFit
            cell.providerImageView.layer.borderColor = UIColor.blue.cgColor
            cell.providerImageView.layer.borderWidth = 1
        }
        return cell
    }
    
}

public class ProviderCell: UITableViewCell {
    var providerImageView: UIImageView!{
        didSet {
            guard let imageView = providerImageView else { return }
            self.addSubview(imageView)
        }
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        guard let imageView = providerImageView else { return }
        imageView.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class ProviderCollectionCell: UICollectionViewCell {
    var providerImageView: UIImageView!{
        didSet {
            guard let imageView = providerImageView else { return }
            self.addSubview(imageView)
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        guard let imageView = providerImageView else { return }
        imageView.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ProviderHeaderView: UICollectionReusableView {
    var headerLabel: UILabel! {
        didSet {
            guard let headerLabel = headerLabel else { return }
            self.addSubview(headerLabel)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        guard let headerLabel = headerLabel else { return }
        headerLabel.removeFromSuperview()
    }
}

class GridFlowLayout: UICollectionViewFlowLayout {
    
    // here you can define the height of each cell
    let itemHeight: CGFloat = 100
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    /**
     Sets up the layout for the collectionView. 1pt distance between each cell and 1pt distance between each row plus use a vertical layout
     */
    func setupLayout() {
        minimumInteritemSpacing = 10
        minimumLineSpacing = 10
        scrollDirection = .vertical
    }
    
    /// here we define the width of each cell, creating a 2 column layout. In case you would create 3 columns, change the number 2 to 3
    var itemWidth: CGFloat {
//        return collectionView!.frame.width / 3 - 1
        100
    }
    
    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width: itemWidth, height: itemHeight)
            
        }
        get {
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return collectionView!.contentOffset
    }
}
