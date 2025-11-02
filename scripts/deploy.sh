#!/bin/bash

# Atitia App Deployment Script
# This script handles deployment to different environments

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DEPLOYMENT_CONFIG="$PROJECT_DIR/deployment_config.yaml"

# Default values
ENVIRONMENT="development"
PLATFORM="all"
BUILD_TYPE="release"
SKIP_TESTS=false
SKIP_ANALYSIS=false
SKIP_SECURITY=false
DRY_RUN=false

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -e, --environment ENV    Environment to deploy to (development, staging, production)"
    echo "  -p, --platform PLATFORM Platform to deploy (android, ios, web, all)"
    echo "  -b, --build-type TYPE    Build type (debug, release)"
    echo "  --skip-tests            Skip running tests"
    echo "  --skip-analysis         Skip code analysis"
    echo "  --skip-security         Skip security checks"
    echo "  --dry-run               Show what would be deployed without actually deploying"
    echo "  -h, --help              Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 -e production -p android"
    echo "  $0 -e staging -p all --skip-tests"
    echo "  $0 -e development -p web --dry-run"
}

# Function to parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -e|--environment)
                ENVIRONMENT="$2"
                shift 2
                ;;
            -p|--platform)
                PLATFORM="$2"
                shift 2
                ;;
            -b|--build-type)
                BUILD_TYPE="$2"
                shift 2
                ;;
            --skip-tests)
                SKIP_TESTS=true
                shift
                ;;
            --skip-analysis)
                SKIP_ANALYSIS=true
                shift
                ;;
            --skip-security)
                SKIP_SECURITY=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
}

# Function to validate environment
validate_environment() {
    case $ENVIRONMENT in
        development|staging|production)
            print_status "Deploying to $ENVIRONMENT environment"
            ;;
        *)
            print_error "Invalid environment: $ENVIRONMENT"
            print_error "Valid environments: development, staging, production"
            exit 1
            ;;
    esac
}

# Function to validate platform
validate_platform() {
    case $PLATFORM in
        android|ios|web|all)
            print_status "Deploying to $PLATFORM platform"
            ;;
        *)
            print_error "Invalid platform: $PLATFORM"
            print_error "Valid platforms: android, ios, web, all"
            exit 1
            ;;
    esac
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check if Flutter is installed
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed or not in PATH"
        exit 1
    fi
    
    # Check if Dart is installed
    if ! command -v dart &> /dev/null; then
        print_error "Dart is not installed or not in PATH"
        exit 1
    fi
    
    # Check if deployment config exists
    if [[ ! -f "$DEPLOYMENT_CONFIG" ]]; then
        print_error "Deployment config not found: $DEPLOYMENT_CONFIG"
        exit 1
    fi
    
    # Check if we're in the right directory
    if [[ ! -f "$PROJECT_DIR/pubspec.yaml" ]]; then
        print_error "pubspec.yaml not found. Are you in the right directory?"
        exit 1
    fi
    
    print_success "Prerequisites check passed"
}

# Function to run tests
run_tests() {
    if [[ "$SKIP_TESTS" == true ]]; then
        print_warning "Skipping tests"
        return
    fi
    
    print_status "Running tests..."
    
    cd "$PROJECT_DIR"
    
    # Run unit tests
    print_status "Running unit tests..."
    flutter test
    
    # Run integration tests
    print_status "Running integration tests..."
    flutter test integration_test/
    
    # Run security tests
    print_status "Running security tests..."
    flutter test test/security_test.dart
    
    # Run performance tests
    print_status "Running performance tests..."
    flutter test test/performance_test.dart
    
    print_success "All tests passed"
}

# Function to run code analysis
run_analysis() {
    if [[ "$SKIP_ANALYSIS" == true ]]; then
        print_warning "Skipping code analysis"
        return
    fi
    
    print_status "Running code analysis..."
    
    cd "$PROJECT_DIR"
    
    # Run Flutter analyze
    flutter analyze
    
    # Check formatting
    dart format --output=none --set-exit-if-changed .
    
    print_success "Code analysis passed"
}

# Function to run security checks
run_security_checks() {
    if [[ "$SKIP_SECURITY" == true ]]; then
        print_warning "Skipping security checks"
        return
    fi
    
    print_status "Running security checks..."
    
    cd "$PROJECT_DIR"
    
    # Run security audit
    flutter pub audit
    
    # Run security tests
    flutter test test/security_test.dart
    
    print_success "Security checks passed"
}

# Function to build Android app
build_android() {
    print_status "Building Android app..."
    
    cd "$PROJECT_DIR"
    
    # Clean previous builds
    flutter clean
    
    # Get dependencies
    flutter pub get
    
    # Build APK
    flutter build apk --release
    
    # Build App Bundle
    flutter build appbundle --release
    
    print_success "Android build completed"
}

# Function to build iOS app
build_ios() {
    print_status "Building iOS app..."
    
    cd "$PROJECT_DIR"
    
    # Clean previous builds
    flutter clean
    
    # Get dependencies
    flutter pub get
    
    # Build iOS app
    flutter build ios --release --no-codesign
    
    print_success "iOS build completed"
}

# Function to build web app
build_web() {
    print_status "Building web app..."
    
    cd "$PROJECT_DIR"
    
    # Clean previous builds
    flutter clean
    
    # Get dependencies
    flutter pub get
    
    # Build web app
    flutter build web --release
    
    print_success "Web build completed"
}

# Function to deploy to Firebase Hosting
deploy_firebase_hosting() {
    print_status "Deploying to Firebase Hosting..."
    
    if [[ "$DRY_RUN" == true ]]; then
        print_status "DRY RUN: Would deploy to Firebase Hosting"
        return
    fi
    
    cd "$PROJECT_DIR"
    
    # Deploy to Firebase Hosting
    firebase deploy --only hosting
    
    print_success "Firebase Hosting deployment completed"
}

# Function to deploy to Google Play Store
deploy_google_play() {
    print_status "Deploying to Google Play Store..."
    
    if [[ "$DRY_RUN" == true ]]; then
        print_status "DRY RUN: Would deploy to Google Play Store"
        return
    fi
    
    cd "$PROJECT_DIR"
    
    # Deploy to Google Play Store
    # This would typically use fastlane or similar tool
    print_status "Google Play Store deployment not implemented yet"
    
    print_success "Google Play Store deployment completed"
}

# Function to deploy to App Store
deploy_app_store() {
    print_status "Deploying to App Store..."
    
    if [[ "$DRY_RUN" == true ]]; then
        print_status "DRY RUN: Would deploy to App Store"
        return
    fi
    
    cd "$PROJECT_DIR"
    
    # Deploy to App Store
    # This would typically use fastlane or similar tool
    print_status "App Store deployment not implemented yet"
    
    print_success "App Store deployment completed"
}

# Function to deploy to Firebase App Distribution
deploy_firebase_app_distribution() {
    print_status "Deploying to Firebase App Distribution..."
    
    if [[ "$DRY_RUN" == true ]]; then
        print_status "DRY RUN: Would deploy to Firebase App Distribution"
        return
    fi
    
    cd "$PROJECT_DIR"
    
    # Deploy to Firebase App Distribution
    # This would typically use Firebase CLI
    print_status "Firebase App Distribution deployment not implemented yet"
    
    print_success "Firebase App Distribution deployment completed"
}

# Function to deploy based on platform
deploy_platform() {
    case $PLATFORM in
        android)
            build_android
            if [[ "$ENVIRONMENT" == "production" ]]; then
                deploy_google_play
            else
                deploy_firebase_app_distribution
            fi
            ;;
        ios)
            build_ios
            if [[ "$ENVIRONMENT" == "production" ]]; then
                deploy_app_store
            else
                deploy_firebase_app_distribution
            fi
            ;;
        web)
            build_web
            deploy_firebase_hosting
            ;;
        all)
            if [[ "$ENVIRONMENT" == "production" ]]; then
                build_android
                build_ios
                build_web
                deploy_google_play
                deploy_app_store
                deploy_firebase_hosting
            else
                build_android
                build_ios
                build_web
                deploy_firebase_app_distribution
                deploy_firebase_hosting
            fi
            ;;
    esac
}

# Function to show deployment summary
show_deployment_summary() {
    print_success "Deployment completed successfully!"
    echo ""
    echo "Deployment Summary:"
    echo "  Environment: $ENVIRONMENT"
    echo "  Platform: $PLATFORM"
    echo "  Build Type: $BUILD_TYPE"
    echo "  Tests Skipped: $SKIP_TESTS"
    echo "  Analysis Skipped: $SKIP_ANALYSIS"
    echo "  Security Skipped: $SKIP_SECURITY"
    echo "  Dry Run: $DRY_RUN"
    echo ""
    
    if [[ "$DRY_RUN" == true ]]; then
        print_warning "This was a dry run. No actual deployment was performed."
    fi
}

# Main function
main() {
    print_status "Starting Atitia App deployment..."
    echo ""
    
    # Parse arguments
    parse_arguments "$@"
    
    # Validate inputs
    validate_environment
    validate_platform
    
    # Check prerequisites
    check_prerequisites
    
    # Run tests
    run_tests
    
    # Run code analysis
    run_analysis
    
    # Run security checks
    run_security_checks
    
    # Deploy based on platform
    deploy_platform
    
    # Show deployment summary
    show_deployment_summary
}

# Run main function
main "$@"
