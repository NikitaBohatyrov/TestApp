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

    var sections = [Section]()
    
    var updatedValue:Any?
    
    init(with data:Any,start:Bool = false){
        super.init(nibName: nil, bundle: nil)
        self.updatedValue = data
    }
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let value = updatedValue{
            
            viewModel.updateSection(updatedData: value) {[weak self] updatedSections in
                self?.sections = updatedSections
                
                DispatchQueue.main.async {[weak self] in
                    self?.tableView.reloadData()
                }
            }
        }else{
            viewModel.getDevices {[weak self] sections in
                self?.sections = sections
                DispatchQueue.main.async {[weak self] in
                    self?.tableView.reloadData()
                }
            }
        }
        createView()
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
            cell.title.font = .systemFont(ofSize: tableView.frame.size.height/36)
            cell.title.textColor = UIColor(named: "LightGray")
            cell.configure(with: sections[indexPath.section].title)
            return cell
        }else {
            let model = sections[indexPath.section].content[indexPath.row-1]

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
            sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .none)
        }else {
            coordinator?.eventOccured(with: .cellTapped, data: sections[indexPath.section].content[indexPath.row-1])
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
