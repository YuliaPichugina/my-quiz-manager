//
//  QuizManagerUITests.swift
//  MyQuizManagerUITests
//
//  Created by Yulia Pichugina on 18/02/2021.
//

import XCTest

//to run this test case correctly please check your simulator and make sure 'Hardware -> Keyboard -> Connect hardware keyboard' is off.

class QuizManagerUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        app = XCUIApplication()
        
    }
    override func tearDown() {
        
        app = nil
        
        super.tearDown()
    }
    
    //MARK: Login Page Tests
    
    func test_InitialViewAppearsCorrectly() {
        
        app.launch()
        
        XCTAssert(app.staticTexts["My Quiz Manager"].exists)
        XCTAssert(app.textFields["User name"].exists)
        XCTAssert(app.secureTextFields["Password"].exists)
        XCTAssert(app.buttons["Log In"].exists)
        
    }
    
    func test_noUsernameAndPasswordProvided_TapLogInButton_showsLogInViewWithErrorMessage() {
        
        app.launch()
        app.buttons["Log In"].tap()
        
        XCTAssert(app.staticTexts["Your username and/or password is incorrect. Please try again."].exists)
        XCTAssert(app.buttons["Log In"].exists)
    }
    
    func test_incorrectUsernameAndPasswordProvided_TapLogInButton_showsLogInViewWithErrorMessage() {
        
        app.launch()
        userLogIn(username: "John", password: "Password")
        app.buttons["Log In"].tap()
        
        XCTAssert(app.staticTexts["Your username and/or password is incorrect. Please try again."].exists)
        XCTAssert(app.buttons["Log In"].exists)
    }
    

    func test_correctUsernameAndPasswordProvided_TapLogInButton_opensDashboard() {
        
        app.launch()
        userLogIn(username: "Anna", password: "Password106")
        
        XCTAssert(app.navigationBars["All quizzes"].exists)
        XCTAssert(app.buttons["Log out"].exists)
    }
    
    //MARK: Dashboard Tests
    
    func test_userWithRestrictedPermissions_userSeesDashboard_noAddQuizButtonOnDashboard() {
        
        app.launch()
        userLogIn(username: "Tom", password: "Password123")
        
        XCTAssertFalse(app.buttons["Add Quiz"].exists)
    }
    
    func test_userWithViewPermissions_userSeesDashboard_noAddQuizButtonOnDashboard() {
        
        app.launch()
        userLogIn(username: "Ellie", password: "Password456")
        
        XCTAssertFalse(app.buttons["Add Quiz"].exists)
    }
    
    func test_userWithEditPermissions_userSeesDashboard_noAddQuizButtonOnDashboard() {
        
        app.launch()
        userLogIn(username: "Anna", password: "Password106")
        
        XCTAssert(app.buttons["Add Quiz"].exists)
    }
    
    //MARK: Add Quiz View Tests
    
    func test_userWithEditPermissions_userOnAddQuizView_viewConfiguresCorrectly() {
        
        app.launch()
        userLogIn(username: "Anna", password: "Password106")
        
        app.buttons["Add Quiz"].tap()
        
        XCTAssert(app.textFields["Enter your quiz name"].exists)
        XCTAssert(app.buttons["Save"].exists)
    }
    
    //MARK: Test helpers
    
    func userLogIn(username: String, password: String) {
        
        let usernameTextField = app.textFields.element
        
        usernameTextField.tap()
        usernameTextField.typeText(username)
        
        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText(password)
        
        app.buttons["Log In"].tap()
    }
}
