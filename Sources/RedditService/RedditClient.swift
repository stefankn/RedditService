//
//  RedditClient.swift
//  
//
//  Created by Stefan Klein Nulent on 05/03/2021.
//

import Foundation
import Combine

public class RedditClient {

    // MARK: - Constants
    
    private static let accessTokenDefaultsKey = "RedditService.AccessToken"
    
    

    // MARK: - Private Properties

    private let authorizationService: AuthorizationService
    private var accountService: AccountService { AccountService(accessToken: accessToken) }
    private var subredditService: SubredditsService { SubredditsService(accessToken: accessToken) }
    private var commentsService: CommentsService { CommentsService(accessToken: accessToken) }
    
    private var accessToken: AccessToken? {
        didSet {
            if
                let accessToken = accessToken,
                let data = try? JSONEncoder().encode(accessToken) {

                UserDefaults.standard.set(data, forKey: Self.accessTokenDefaultsKey)
                isAuthorized.send(true)
            } else {
                UserDefaults.standard.removeObject(forKey: Self.accessTokenDefaultsKey)
                isAuthorized.send(false)
            }
        }
    }
    
    
    
    // MARK: - Properties
    
    public let isAuthorized = CurrentValueSubject<Bool, Never>(false)
    
    
    
    // MARK: - Construction
    
    public init(appIdentifier: String, redirectURI: String) {
        if
            let data = UserDefaults.standard.data(forKey: Self.accessTokenDefaultsKey),
            let accessToken = try? JSONDecoder().decode(AccessToken.self, from: data) {

            self.accessToken = accessToken
            self.isAuthorized.send(true)
        }
        
        authorizationService = AuthorizationService(appIdentifier: appIdentifier, redirectURI: redirectURI)
    }
    
    
    
    // MARK: - Functions
    
    public func getIdentity() -> AnyPublisher<Identity, Error> {
        perform{ self.accountService.getIdentitity() }
    }
    
    public func getHomeMessage(after: String? = nil, before: String? = nil, count: Int? = nil, limit: Int? = nil) -> AnyPublisher<MessagesPager, Error> {
        perform{ self.subredditService.getHomeMessages(after: after, before: before, count: count, limit: limit) }
    }
    
    public func getSubscribedSubreddits(after: String? = nil, before: String? = nil, count: Int? = nil, limit: Int? = nil) -> AnyPublisher<SubredditsPager, Error> {
        perform{ self.subredditService.getSubscribedSubreddits(after: after, before: before, count: count, limit: limit) }
    }
    
    public func getMessages(for subreddit: Subreddit, after: String? = nil, before: String? = nil, count: Int? = nil, limit: Int? = nil) -> AnyPublisher<MessagesPager, Error> {
        perform{ self.subredditService.getMessages(for: subreddit, after: after, before: before, count: count, limit: limit) }
    }
    
    public func commentForest(for message: Message, sorting: CommentSorting = .new, limit: Int = 10) -> CommentForest {
        CommentForest(client: self, message: message, limit: limit, sorting: sorting)
    }

    public func generateAuthorizationURL(scope: [Scope], responseType: ResponseType = .code, duration: TokenDuration = .permanent) -> URL {
        authorizationService.generateAuthorizationURL(
            scope: scope,
            responseType: responseType,
            duration: duration
        )
    }
    
    public func handleRedirectURL(_ url: URL) -> AnyPublisher<Void, Error> {
        authorizationService
            .handleRedirectURL(url)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { self.accessToken = $0 })
            .map{ _ in () }
            .eraseToAnyPublisher()
    }
    
    
    
    // MARK: - Internal Functions
    
    func getComments(for message: Message, sorting: CommentSorting = .new, limit: Int = 10) -> AnyPublisher<[CommentElement], Error> {
        perform{ self.commentsService.getComments(for: message, sorting: sorting, limit: limit) }
    }
    
    func moreComments(for message: Message, children: [String], sorting: CommentSorting = .new) -> AnyPublisher<MoreCommentsResponse, Error> {
        perform{ self.commentsService.moreComments(for: message, children: children, sorting: sorting) }
    }
    
    
    
    // MARK: - Private Functions
    
    private func perform<R>(request: @escaping () -> AnyPublisher<R, Error>) -> AnyPublisher<R, Error> {
        request()
            .catch { error -> AnyPublisher<R, Error> in
                if
                    case let Service.ServiceError.failure(response, _) = error,
                    response?.status == .unauthorized,
                    let refreshToken = self.accessToken?.refreshToken {
 
                    return self.authorizationService.refreshAccessToken(refreshToken: refreshToken)
                        .receive(on: DispatchQueue.main)
                        .handleEvents(
                            receiveOutput: { self.accessToken = $0 },
                            receiveCompletion: { result in
                                switch result {
                                case .finished: break
                                case .failure:
                                    self.accessToken = nil
                                }
                            }
                        )
                        .flatMap{ _ in self.perform(request: request) }
                        .eraseToAnyPublisher()
                    
                } else {
                    return Fail(error: error).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
