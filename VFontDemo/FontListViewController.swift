//
//  FontListViewController.swift
//  VFontDemo
//
//  Created by Maxim Skorynin on 25.04.2022.
//

import UIKit
import VFont

class FontListViewController: UIViewController {
    
    private let defaultFontSize: CGFloat = 30.0
    private var fonts: [VFont] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureTableView()
        readFonts()
        
        tableView.reloadData()
    }
    
    // MARK: Functions
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.register(.init(nibName: "FontRow", bundle: nil), forCellReuseIdentifier: "FontRow")
    }
    
    private func readFonts() {
        let names = ["ZvinSerif", "Uncut-Sans"]
        fonts = names.compactMap { VFont(name: $0, size: defaultFontSize) }
    }
    
}

extension FontListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FontRow", for: indexPath) as? FontRow
        
        let font = fonts[indexPath.row]
        cell?.configure(font: font)
        
        return cell ?? .init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fonts.count
    }
    
}
