# AWS Login Manager

AWS Login Manager is a cross-platform Flutter application for macOS, Linux, and Windows that helps manage AWS credentials and facilitates SSO (Single Sign-On) login for AWS services. The application allows users to securely store and manage AWS Access Key ID, Secret Access Key, and perform SSO login to interact with AWS services seamlessly.

## Features

- **AWS Credentials Management**: 
  - Store and manage AWS Access Key ID and Secret Access Key.
  - Export AWS credentials as environment variables for quick access across the system.
  - Copy AWS credentials to the clipboard for easy use in other services.
  
- **SSO Login**:
  - Supports AWS SSO login for AWS services.
  - Allows you to manage AWS SSO credentials and regions.

- **Cross-Platform Support**:
  - Works seamlessly on **macOS**, **Linux**, and **Windows** platforms.

- **Environment Variable Management**:
  - Set AWS credentials as environment variables for use across your system.
  - Clear environment variables when no longer needed.

- **User Interface**:
  - Clean and intuitive UI built using Flutter.
  - Toggle between viewing and hiding secret keys for security.

## Installation

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed on your machine.
- A working development environment for macOS, Linux, or Windows.

### Steps

1. Clone this repository:
```bash
git clone https://github.com/your-repository/aws_login_manager.git
```
2. Navigate to the project directory:
```bash
cd aws_login_manager
```
3. Install dependencies:
```bash
flutter pub get
```
4. Run the application on your desired platform:
 - macOS 
    ```bash
    flutter run -d macos
    ```
 - Linux 
    ```bash
    flutter run -d linux
    ```
 - Windows 
    ```bash
    flutter run -d windows
    ```
## Usage

1. **Managing AWS Credentials**:
   - Enter your AWS Access Key ID and AWS Secret Access Key in the respective fields.
   - You can copy the credentials to your clipboard using the copy button.
 

2. **AWS SSO Login**:
   - If you're using AWS SSO, you can enter the region and initiate an SSO login for access to AWS services.
   - After successful login, AWS credentials will be available for use.

3. **Environment Variables**:
   - The app allows you to set AWS credentials as environment variables for your system.
   - You can easily clear these environment variables when they are no longer needed.
