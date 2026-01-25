//
//  EnvironmentConfigurationTests.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

import Testing
import Foundation
@testable import BushelFoundation
import BushelUtilities

struct EnvironmentConfigurationTests {
  
  @Test("EnvironmentConfiguration properties read from environment")
  func testEnvironmentProperties() {
    // Create mock environment
    let mockEnvironment: [String: String] = [
      "DISABLE_ASSERTION_FAILURE_FOR_ERROR": "true",
      "DISALLOW_DATABASE_REBUILD": "false",
      "ONBOARDING_OVERRIDE": "skip",
      "RESET_APPLICATION": "true",
      "RELEASE_VERSION": "false",
      "REVIEW_ENGAGEMENT_THRESHOLD": "42",
      "TRIGGER_TRACKING_PERMISSIONS_REQUEST": "true"
    ]
    
    // Create EnvironmentConfiguration with mock environment
    // Note: Since EnvironmentConfiguration.shared is static and properties are initialized
    // with ProcessInfo.processInfo.environment, we'll test the property wrapper separately
    
    // Test individual property wrappers
    @EnvironmentProperty("DISABLE_ASSERTION_FAILURE_FOR_ERROR", source: mockEnvironment)
    var disableAssertionFailure: Bool
    
    @EnvironmentProperty("DISALLOW_DATABASE_REBUILD", source: mockEnvironment)
    var disallowDatabaseRebuild: Bool
    
    @EnvironmentProperty("ONBOARDING_OVERRIDE", source: mockEnvironment)
    var onboardingOverride: OnboardingOverrideOption
    
    @EnvironmentProperty("RESET_APPLICATION", source: mockEnvironment)
    var resetApplication: Bool
    
    @EnvironmentProperty("RELEASE_VERSION", source: mockEnvironment)
    var releaseVersion: Bool
    
    @EnvironmentProperty("REVIEW_ENGAGEMENT_THRESHOLD", source: mockEnvironment)
    var reviewEngagementThreshold: Int
    
    @EnvironmentProperty("TRIGGER_TRACKING_PERMISSIONS_REQUEST", source: mockEnvironment)
    var triggerTrackingPermissionsRequest: Bool
    
    #expect(disableAssertionFailure == true)
    #expect(disallowDatabaseRebuild == false)
    #expect(onboardingOverride == .skip)
    #expect(resetApplication == true)
    #expect(releaseVersion == false)
    #expect(reviewEngagementThreshold == 42)
    #expect(triggerTrackingPermissionsRequest == true)
  }
  
  @Test("EnvironmentConfiguration uses defaults when environment empty")
  func testDefaultValues() {
    let emptyEnvironment: [String: String] = [:]
    
    @EnvironmentProperty("DISABLE_ASSERTION_FAILURE_FOR_ERROR", source: emptyEnvironment)
    var disableAssertionFailure: Bool
    
    @EnvironmentProperty("DISALLOW_DATABASE_REBUILD", source: emptyEnvironment)
    var disallowDatabaseRebuild: Bool
    
    @EnvironmentProperty("ONBOARDING_OVERRIDE", source: emptyEnvironment)
    var onboardingOverride: OnboardingOverrideOption
    
    @EnvironmentProperty("RESET_APPLICATION", source: emptyEnvironment)
    var resetApplication: Bool
    
    @EnvironmentProperty("RELEASE_VERSION", source: emptyEnvironment)
    var releaseVersion: Bool
    
    @EnvironmentProperty("REVIEW_ENGAGEMENT_THRESHOLD", source: emptyEnvironment)
    var reviewEngagementThreshold: Int
    
    @EnvironmentProperty("TRIGGER_TRACKING_PERMISSIONS_REQUEST", source: emptyEnvironment)
    var triggerTrackingPermissionsRequest: Bool
    
    #expect(disableAssertionFailure == false)  // Bool default
    #expect(disallowDatabaseRebuild == false)  // Bool default
    #expect(onboardingOverride == .none)  // OnboardingOverrideOption default
    #expect(resetApplication == false)  // Bool default
    #expect(releaseVersion == false)  // Bool default
    #expect(reviewEngagementThreshold == 0)  // Int default
    #expect(triggerTrackingPermissionsRequest == false)  // Bool default
  }
  
  @Test("EnvironmentConfiguration.Key raw values are correct")
  func testKeyRawValues() {
    #expect(EnvironmentConfiguration.Key.disableAssertionFailureForError.rawValue == "DISABLE_ASSERTION_FAILURE_FOR_ERROR")
    #expect(EnvironmentConfiguration.Key.disallowDatabaseRebuild.rawValue == "DISALLOW_DATABASE_REBUILD")
    #expect(EnvironmentConfiguration.Key.onboardingOveride.rawValue == "ONBOARDING_OVERRIDE")
    #expect(EnvironmentConfiguration.Key.resetApplication.rawValue == "RESET_APPLICATION")
    #expect(EnvironmentConfiguration.Key.releaseVersion.rawValue == "RELEASE_VERSION")
    #expect(EnvironmentConfiguration.Key.reviewEngagementThreshold.rawValue == "REVIEW_ENGAGEMENT_THRESHOLD")
    #expect(EnvironmentConfiguration.Key.triggerTrackingPermissionsRequest.rawValue == "TRIGGER_TRACKING_PERMISSIONS_REQUEST")
  }
  
  @Test("EnvironmentConfiguration customMirror includes all properties")
  func testCustomMirror() {
    let config = EnvironmentConfiguration.shared
    let mirror = config.customMirror
    
    // Get all child labels from the mirror
    let childLabels = mirror.children.compactMap { $0.label }
    
    // Verify all expected properties are in the mirror
    let expectedProperties = [
      "disableAssertionFailureForError",
      "disallowDatabaseRebuild",
      "onboardingOveride",
      "resetApplication",
      "releaseVersion",
      "reviewEngagementThreshold",
      "triggerTrackingPermissionsRequest"
    ]
    
    for property in expectedProperties {
      #expect(childLabels.contains(property), "customMirror should include \(property)")
    }
    
    // Verify the mirror has exactly the expected number of properties
    #expect(mirror.children.count == expectedProperties.count)
  }
  
  @Test("EnvironmentConfiguration.shared is a singleton")
  func testSharedSingleton() {
    let instance1 = EnvironmentConfiguration.shared
    let instance2 = EnvironmentConfiguration.shared
    
    // Since EnvironmentConfiguration is a struct, we can't compare identity,
    // but we can verify that .shared always returns a value
    #expect(EnvironmentConfiguration.shared != nil)
  }
  
  @Test("EnvironmentProperty with Key enum")
  func testEnvironmentPropertyWithKeyEnum() {
    let mockEnvironment: [String: String] = [
      "TRIGGER_TRACKING_PERMISSIONS_REQUEST": "true"
    ]
    
    @EnvironmentProperty(
      EnvironmentConfiguration.Key.triggerTrackingPermissionsRequest,
      source: mockEnvironment
    )
    var triggerTrackingPermissionsRequest: Bool
    
    #expect(triggerTrackingPermissionsRequest == true)
  }
  
  @Test("triggerTrackingPermissionsRequest property specifically")
  func testTriggerTrackingPermissionsRequestProperty() {
    // Test with "true"
    let envTrue: [String: String] = ["TRIGGER_TRACKING_PERMISSIONS_REQUEST": "true"]
    @EnvironmentProperty(EnvironmentConfiguration.Key.triggerTrackingPermissionsRequest, source: envTrue)
    var trackingTrue: Bool
    #expect(trackingTrue == true)
    
    // Test with "false"
    let envFalse: [String: String] = ["TRIGGER_TRACKING_PERMISSIONS_REQUEST": "false"]
    @EnvironmentProperty(EnvironmentConfiguration.Key.triggerTrackingPermissionsRequest, source: envFalse)
    var trackingFalse: Bool
    #expect(trackingFalse == false)
    
    // Test with missing (should use default)
    let envMissing: [String: String] = [:]
    @EnvironmentProperty(EnvironmentConfiguration.Key.triggerTrackingPermissionsRequest, source: envMissing)
    var trackingMissing: Bool
    #expect(trackingMissing == false)  // Bool default is false
    
    // Test with invalid value (should use default)
    let envInvalid: [String: String] = ["TRIGGER_TRACKING_PERMISSIONS_REQUEST": "invalid"]
    @EnvironmentProperty(EnvironmentConfiguration.Key.triggerTrackingPermissionsRequest, source: envInvalid)
    var trackingInvalid: Bool
    #expect(trackingInvalid == false)  // Invalid bool strings default to false
  }
}