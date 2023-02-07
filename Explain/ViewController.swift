//
//  ViewController.swift
//  Explain
//
//  Created by 이병현 on 2023/02/07.
//

import UIKit
import SnapKit
import RxSwift
import SwiftyJSON

let MEMBER_LIST_URL = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"

class 나중에생기는데이터<T> {
    private let task: (@escaping (T) -> Void) -> Void
    
    init(task: @escaping (@escaping (T) -> Void) -> Void) {
        self.task = task
    }
    
    func 나중에오면(_ f: @escaping (T) -> Void) {
        task(f)
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAtrribute()
        setupLayout()
        action()
    }
    
    private let timerLabel = UILabel()
    private let loadButton = UIButton()
    private let editView = UITextView()
    private let activityIndicator = UIActivityIndicatorView()
    
    
    func setupAtrribute() {
        timerLabel.font = UIFont.systemFont(ofSize: 20)
        
        activityIndicator.contentMode = .scaleToFill
        activityIndicator.style = .medium
        
        loadButton.setTitle("LOAD", for: .normal)
        loadButton.backgroundColor = .black
        loadButton.tintColor = .white
        loadButton.addTarget(self, action: #selector(onLoad), for: .touchUpInside)
    }
    func setupLayout() {
        [timerLabel, activityIndicator, loadButton, editView].forEach {
            view.addSubview($0)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(20)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        loadButton.snp.makeConstraints { make in
            make.top.equalTo(activityIndicator.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        editView.snp.makeConstraints { make in
            make.top.equalTo(loadButton.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func action() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.timerLabel.text = "\(Date().timeIntervalSince1970)"
        }
    }
    
    private func setVisibleWithAnimation(_ v: UIView?, _ s: Bool) {
        guard let v = v else { return }
        UIView.animate(withDuration: 0.3, animations: { [weak v] in
            v?.isHidden = !s
        }, completion: { [weak self] _ in
            self?.view.layoutIfNeeded()
        })
    }
    
    func downloadjson(_ url: String) -> 나중에생기는데이터<String?> {
        return 나중에생기는데이터() { f in
            DispatchQueue.global().async {
                let url = URL(string: url)!
                let data = try! Data(contentsOf: url)
                let json = String(data: data, encoding: .utf8)
                
                DispatchQueue.main.async {
                    f(json)
                }
            }
        }
    }
    
    @objc func onLoad() {
        editView.text = ""
        setVisibleWithAnimation(activityIndicator, true)

        let json: 나중에생기는데이터<String?> = downloadjson(MEMBER_LIST_URL)
        
        json.나중에오면 { json in
            self.editView.text = json
            self.setVisibleWithAnimation(self.activityIndicator, false)
        }
    }
}


