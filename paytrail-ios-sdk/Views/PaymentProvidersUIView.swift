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
                    }
                   
                case .failure(let failure):
                    PTLogger.log(message: "Render image failure: \(failure.localizedDescription)", level: .warning)
                    DispatchQueue.main.async {
                        let placeHolder = UIImage(systemName: "exclamationmark.square") ?? UIImage()
                        self.providerWithImages.append((provider, placeHolder))
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        tableView = UITableView(frame: contentFrame)
        tableView.layer.backgroundColor = UIColor.blue.cgColor
        tableView.separatorStyle = .none
        self.addSubview(tableView)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProviderCell.self, forCellReuseIdentifier: "providerCell")

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
