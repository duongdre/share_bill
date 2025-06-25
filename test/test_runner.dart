import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'model/bill_test.dart' as bill_tests;
import 'model/group_test.dart' as group_tests;
import 'model/person_test.dart' as person_tests;
import 'screen/login_screen_test.dart' as login_screen_tests;

/// Main test runner that executes all test suites
///
/// This file serves as a central point to run all tests in the project.
/// You can run specific test suites by commenting out the ones you don't need.
///
/// To run all tests: `flutter test test/test_runner.dart`
/// To run specific tests: `flutter test test/unit/models/bill_test.dart`
void main() {
  group('Share Bill App - All Tests', () {

    group('📦 Unit Tests', () {
      group('🏗️ Models', () {
        group('💰 Bill Model Tests', bill_tests.main);
        group('👥 Group Model Tests', group_tests.main);
        group('👤 Person Model Tests', person_tests.main);
      });
    });

    group('🎨 Widget Tests', () {
      group('🔐 Login Screen Widget Tests', login_screen_tests.main);
    });

    // Note: Integration tests are typically run separately using:
    // flutter test integration_test/app_flow_test.dart
  });
}

/// Test suite information and instructions
///
/// Test Organization:
///
/// 1. **Unit Tests** (test/unit/):
///    - Models: Test data models (Bill, Group, Person)
///    - Providers: Test business logic and state management
///    - Services: Test Firebase and other services
///    - Utils: Test utility functions
///
/// 2. **Widget Tests** (test/widget/):
///    - Individual widget behavior
///    - UI component interactions
///    - Widget state management
///    - Custom widget functionality
///
/// 3. **Integration Tests** (test/integration/):
///    - Complete user flows
///    - Screen-to-screen navigation
///    - End-to-end functionality
///    - Real device testing scenarios
///
/// Running Tests:
///
/// ```bash
/// # Run all tests
/// flutter test
///
/// # Run specific test file
/// flutter test test/unit/models/bill_test.dart
///
/// # Run tests with coverage
/// flutter test --coverage
///
/// # Run widget tests only
/// flutter test test/widget/
///
/// # Run unit tests only
/// flutter test test/unit/
///
/// # Run integration tests
/// flutter test integration_test/
///
/// # Run tests in debug mode
/// flutter test --debug
///
/// # Run tests with verbose output
/// flutter test --verbose
/// ```
///
/// Test Patterns Used:
///
/// 1. **Arrange-Act-Assert (AAA)**:
///    - Arrange: Set up test data and conditions
///    - Act: Execute the code being tested
///    - Assert: Verify the expected outcome
///
/// 2. **Given-When-Then (BDD)**:
///    - Given: Initial state/conditions
///    - When: Action/event occurs
///    - Then: Expected outcome
///
/// 3. **Test Fixtures**:
///    - setUp(): Run before each test
///    - tearDown(): Run after each test
///    - setUpAll(): Run once before all tests in group
///    - tearDownAll(): Run once after all tests in group
///
/// Test Best Practices:
///
/// 1. **Test Naming**:
///    - Use descriptive names that explain what is being tested
///    - Follow pattern: "should [expected behavior] when [condition]"
///
/// 2. **Test Organization**:
///    - Group related tests together
///    - Use nested groups for logical organization
///    - Keep tests independent and isolated
///
/// 3. **Mock Data**:
///    - Use consistent mock data across tests
///    - Create factory methods for test data
///    - Use realistic but simple test scenarios
///
/// 4. **Assertions**:
///    - Use specific assertions over generic ones
///    - Test both positive and negative cases
///    - Verify all important aspects of the behavior
///
/// 5. **Test Coverage**:
///    - Aim for high code coverage but focus on quality
///    - Test edge cases and error conditions
///    - Cover all public APIs and user-facing features
///
/// Mock Strategy:
///
/// - **Models**: No mocking needed, test pure data classes
/// - **Providers**: Mock dependencies like Firebase services
/// - **Widgets**: Mock providers and external dependencies
/// - **Integration**: Minimal mocking, test real user flows
///
/// Continuous Integration:
///
/// These tests should be run in CI/CD pipeline:
/// ```yaml
/// # Example GitHub Actions workflow
/// - name: Run tests
///   run: flutter test --coverage
///
/// - name: Upload coverage
///   run: bash <(curl -s https://codecov.io/bash)
/// ```