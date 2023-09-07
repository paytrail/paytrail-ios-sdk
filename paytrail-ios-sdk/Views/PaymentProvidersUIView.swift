//
//  PaymentProvidersUIView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 7.9.2023.
//

import Foundation
import UIKit

public class PaymentProvidersUIView: UIView {
    
    private let paymentApis = PaytrailPaymentAPIs()
    let themes: PaytrailThemes = .init(viewMode: .normal())
    private var providerImages: [UIImage] = []

    var providers: [PaymentMethodProvider] = []
    var groups: [PaymentMethodGroup] = []
    var currentPaymentRequest: URLRequest?
    
    private struct Constants {
        static let providerWidth: CGFloat = 100
        static let providerHeight: CGFloat = 56
        static let providerCornerRadius: CGFloat = 8
        static let providerShadowRadius: CGFloat = 4
        static let providerImagePadding: CGFloat = 8
    }
    
    private weak var tableView: UITableView!
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        tableView.register(ProviderCell.self, forCellReuseIdentifier: "providerCell")
        
        paymentApis.renderPaymentProviderImage(by: "") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.providerImages.append(success)
            case .failure(let failure):
                PTLogger.log(message: "Render image failure: \(failure.localizedDescription)", level: .warning)
                self.providerImages.append(UIImage(systemName: "exclamationmark.square") ?? UIImage())
            }
        }
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
        cell.providerImageView = UIImageView(image: providerImages[indexPath.row])
        return cell
    }
}

public class ProviderCell: UITableViewCell {
    
    var providerImageView: UIImageView!
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
