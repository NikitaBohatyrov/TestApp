//
//  ViewController.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 05.08.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    let viewModel = MainViewModel()
    var tableView = UITableView(frame: .zero, style: .insetGrouped)
    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getDevices {[weak self] sections in
            self?.sections = sections
            
            DispatchQueue.main.async {[weak self] in
                self?.tableView.reloadData()
            }
        }

        createView()
    }

    private func createView(){
        tableView.frame = view.bounds
        tableView.register(SectionTitileTableViewCell.self, forCellReuseIdentifier: SectionTitileTableViewCell.identifier)
        tableView.register(DevicesTableViewCell.self, forCellReuseIdentifier: DevicesTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
}

extension MainViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
      return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        if section.isOpened{
            return section.content.count + 1
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SectionTitileTableViewCell.identifier,
                                                     for: indexPath) as! SectionTitileTableViewCell
            cell.backgroundColor = UIColor(named: "Brown")
            cell.title.font = .systemFont(ofSize: tableView.frame.size.height/36)
            cell.configure(with: sections[indexPath.section].title)
            return cell
        }else {
            let model = sections[indexPath.section].content[indexPath.row-1]
            let cell = tableView.dequeueReusableCell(withIdentifier: DevicesTableViewCell.identifier,
                                                     for: indexPath) as! DevicesTableViewCell
            
            cell.configure(with:model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .none)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return tableView.frame.size.height/12
        }else {
            return tableView.frame.size.height/10
        }
    }
}
