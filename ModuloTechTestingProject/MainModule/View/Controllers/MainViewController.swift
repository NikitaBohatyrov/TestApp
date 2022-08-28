//
//  ViewController.swift
//  ModuloTechTestingProject
//
//  Created by никита богатырев on 05.08.2022.
//

import UIKit

class MainViewController: UIViewController, Coordinating {
    
    var coordinator: Coordinator?
    let viewModel = MainViewModel()
    
    var tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        setUpViewModel()
    }
    
    private func setUpViewModel(){
        viewModel.loadView()
        viewModel.reloadTableView = {[weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    private func createView(){
        self.view.backgroundColor = UIColor(red: 36/255, green: 36/255, blue: 68/255, alpha: 1)
        tableView.frame = view.bounds
        tableView.register(SectionTitileTableViewCell.self, forCellReuseIdentifier: SectionTitileTableViewCell.identifier)
        tableView.register(DevicesTableViewCell.self, forCellReuseIdentifier: DevicesTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        navigationController?.isNavigationBarHidden = true 
        tableView.backgroundColor = UIColor(red: 36/255, green: 36/255, blue: 68/255, alpha: 1)
    }
}

extension MainViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = viewModel.sections[section]
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
            cell.title.font = .systemFont(ofSize: tableView.frame.size.height/36)
            cell.title.textColor = UIColor(named: "LightGray")
            cell.configure(with: viewModel.sections[indexPath.section].title)
            return cell
        }else {
            let model = viewModel.sections[indexPath.section].content[indexPath.row-1]

            let cell = tableView.dequeueReusableCell(withIdentifier: DevicesTableViewCell.identifier,
                                                     for: indexPath) as! DevicesTableViewCell
            cell.backgroundColor = UIColor(red: 70/255, green: 100/255, blue: 140/255, alpha: 1)
            cell.deviceName.font = .systemFont(ofSize: tableView.frame.size.height/38)
            cell.stateLabel.font = .systemFont(ofSize: tableView.frame.size.height/42)
            cell.configure(with:model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            viewModel.sections[indexPath.section].isOpened = !viewModel.sections[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .none)
        }else {
            if indexPath.section == 0 {
               let cellViewModel = viewModel.getLightCellViewModel(at: indexPath)
                coordinator?.eventOccured(with: .cellTapped, data: cellViewModel)
            }else if indexPath.section == 1 {
               let cellViewModel = viewModel.getRollerShutterCellViewModel(at: indexPath)
                coordinator?.eventOccured(with: .cellTapped, data: cellViewModel)
            }else {
              let  cellViewModel = viewModel.getHeaterCellViewModel(at: indexPath)
                coordinator?.eventOccured(with: .cellTapped, data: cellViewModel)
            }
            
           
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
