//
//  VFontViewController.swift
//  VFontDemo
//
//  Created by Maxim Skorynin on 20.04.2022.
//

import UIKit
import VFont

final class VFontViewController: UIViewController {
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    private(set) var vFont: VFont!
    private var axes: [Axis] = []
    
    // MARK: Life Cycle
    
    static func instance(vFont: VFont) -> VFontViewController? {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VFontViewController") as? VFontViewController
        controller?.vFont = vFont
        controller?.axes = Array(vFont.axes.values)
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = vFont?.name
        textLabel.font = vFont?.uiFont
        
        vFont.updated = { [weak self] font in
            self?.textLabel.font = font
        }
        
        configureTableView()
    }
    
    // MARK: Functions
    
    private func configureTableView() {
        tableView.transform = .init(rotationAngle: .pi)
        
        tableView.dataSource = self
        tableView.register(.init(nibName: AxisRow.id, bundle: nil), forCellReuseIdentifier: AxisRow.id)
    }
    
}

// MARK: - UITableView DataSource

extension VFontViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: AxisRow.id, for: indexPath) as? AxisRow
        let axis = axes[indexPath.row]
        
        row?.configure(axis: axis)
        row?.delegate = self
        
        row?.transform = .init(rotationAngle: .pi)
        
        return row ?? .init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return axes.count
    }
    
}

// MARK: - AxisRow Delegate

extension VFontViewController: AxisRowDelegate {
    
    func axisDidChange(_ axis: Axis, value: CGFloat) {
        vFont.setValue(value, forAxisID: axis.id)
    }
    
}

