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
    
    let themes: PaytrailThemes = .init(viewMode: .normal())
    private var providerImages: [UIImage] = []
    
    private var providerWithImages: [ProviderWithImage] = []

    public var providers: [PaymentMethodProvider]
    public var groups: [PaymentMethodGroup]
    var currentPaymentRequest: URLRequest?
    
    private var contentFrame: CGRect
    
    private var collectionView: UICollectionView!
    
    public init(frame: CGRect, providers: [PaymentMethodProvider], groups: [PaymentMethodGroup]) {
        
        self.providers = providers
        self.groups = groups
        self.contentFrame = frame
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        for provider in providers {
            PaytrailPaymentAPIs.renderPaymentProviderImage(by: provider.icon ?? "") { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let success):
                    DispatchQueue.main.async {
                        self.providerWithImages.append((provider, success))
                        self.collectionView.reloadData()
                    }
                   
                case .failure(let failure):
                    PTLogger.log(message: "Render image failure: \(failure.localizedDescription)", level: .warning)
                    DispatchQueue.main.async {
                        let placeHolder = UIImage(systemName: "exclamationmark.square") ?? UIImage()
                        self.providerWithImages.append((provider, placeHolder))
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        
        let gridLayout = GridFlowLayout()
        gridLayout.headerReferenceSize = CGSize(width: contentFrame.width, height: 50)
        collectionView = UICollectionView(frame: contentFrame, collectionViewLayout: gridLayout)
        collectionView.backgroundColor = .clear
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

extension PaymentProvidersUIView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let rows = providers.filter { $0.group == groups[section].id }
        return rows.count
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        groups.count
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
            cell.providerImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 56)
            cell.providerImageView.backgroundColor = .white
            cell.providerImageView.contentMode = .scaleAspectFit
            cell.providerImageView.layer.cornerRadius = 8
        }
        return cell
    }
    
}

public class ProviderCollectionCell: UICollectionViewCell {
    var providerImageView: UIImageView!{
        didSet {
            guard let imageView = providerImageView else { return }
            outerView!.addSubview(imageView)
            self.addSubview(outerView!)
        }
    }
    private var outerView: UIView!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        outerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 56))
        outerView.clipsToBounds = false
        outerView.layer.shadowColor = UIColor.gray.cgColor
        outerView.layer.shadowOpacity = 0.3
        outerView.layer.shadowOffset = CGSize.zero
        outerView.layer.shadowRadius = 4
        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: 8).cgPath
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        guard let imageView = providerImageView else { return }
        imageView.removeFromSuperview()
        outerView!.removeFromSuperview()
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
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
        scrollDirection = .vertical
    }
    
    /// here we define the width of each cell, creating a 2 column layout. In case you would create 3 columns, change the number 2 to 3
    var itemWidth: CGFloat {
        return (collectionView!.frame.width / 3) - 1
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


