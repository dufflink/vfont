//
//  FontListViewController.swift
//  VFontDemo
//
//  Created by Maxim Skorynin on 25.04.2022.
//

import UIKit
import VFont

final class FontListViewController: UIViewController {
    
    private let defaultFontSize: CGFloat = 30.0
    private var vFonts: [VFont] = []
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readFonts()
        
        if vFonts.isEmpty {
            tableView.isHidden = true
        } else {
            configureTableView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: Functions
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(.init(nibName: FontRow.id, bundle: nil), forCellReuseIdentifier: FontRow.id)
    }
    
    private func readFonts() {
        guard let fontNames = InfoPlistReader().getFontNames() else {
            return
        }
        
        vFonts = fontNames.compactMap { VFont(name: $0, size: defaultFontSize) }
    }
    
}

// MARK: - UITableView DataSource & UITableViewDelegate

extension FontListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: FontRow.id, for: indexPath) as? FontRow
        
        let vFont = vFonts[indexPath.row]
        row?.configure(vFont: vFont)
        
        return row ?? .init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vFonts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vFont = vFonts[indexPath.row]
        
        guard let vFontViewController = VFontViewController.instance(vFont: vFont) else {
            return
        }
        
        navigationController?.pushViewController(vFontViewController, animated: true)
    }
    
}
