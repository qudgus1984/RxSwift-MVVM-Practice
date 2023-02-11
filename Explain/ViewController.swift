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
/*
 class Observable<T> {
 private let task: (@escaping (T) -> Void) -> Void
 
 init(task: @escaping (@escaping (T) -> Void) -> Void) {
 self.task = task
 }
 
 func subscribe(_ f: @escaping (T) -> Void) {
 task(f)
 }
 }
 */
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
    
    var disposeBag = DisposeBag()
    
    
    func setupAtrribute() {
        timerLabel.font = UIFont.systemFont(ofSize: 20)
        
        activityIndicator.contentMode = .scaleToFill
        activityIndicator.style = .medium
        loadButton.setTitle("Minju", for: .normal)
        loadButton.backgroundColor = .blue
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
    
    // PromiseKit
    // Bolt
    // RxSwift
    
    // Observable의 생명주기
    // 1. Create
    // 2. Subscribe
    // 3. onNext
    // ---- 끝 ----
    // 4. onCompleted / onError
    // 5. Disposed
    
    func downloadjson(_ url: String) -> Observable<String> {
        // 1. 비동기로 생기는 데이터를 Observable로 감싸서 리턴하는 방법
        Observable.create() { emitter in
            let url = URL(string: url)!
            let task = URLSession.shared.dataTask(with: url) { (data, _, err) in
                guard err == nil else {
                    emitter.onError(err!)
                    return
                }
                
                if let dat = data, let json = String(data: dat, encoding: .utf8) {
                    emitter.onNext(json)
                }
                
                emitter.onCompleted()
            }
            
            task.resume()
            
            return Disposables.create() {
                task.cancel()
            }
        }
        
        
        //        return Observable.create { f in
        //            DispatchQueue.global().async {
        //                let url = URL(string: url)!
        //                let data = try! Data(contentsOf: url)
        //                let json = String(data: data, encoding: .utf8)
        //
        //                DispatchQueue.main.async {
        //                    f.onNext(json)
        //                }
        //            }
        //            return Disposables.create()
        //        }
    }
    
    // Operator은 마블 다이어그램만 이해한다면 찾아서 적재적소에 사용 가능.
    @objc func onLoad() {
        editView.text = ""
        setVisibleWithAnimation(activityIndicator, true)
        
        // 2. Observable로 오는 데이터를 받아서 처리하는 방법
        
        let jsonObservable = downloadjson(MEMBER_LIST_URL)
        let helloObservable = Observable.just("hello world")
        
        Observable.zip(jsonObservable, helloObservable) { $1 + "\n" + $0 } // Observable 합치기
//        _ = downloadjson(MEMBER_LIST_URL) // just, from
//            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
//            .map { json in json?.count ?? 0 } // operator
//            .filter { cnt in cnt > 0 } // operator
//            .map { "\($0)" } // operator
            .observeOn(MainScheduler.instance) // super : operator
            .subscribe(onNext: { json in
                self.editView.text = json
                self.setVisibleWithAnimation(self.activityIndicator, false)
            })
            .disposed(by: disposeBag)
    }
}


