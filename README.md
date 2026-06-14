# Leave Management System - Employee Mobile Application

## Overview

The Leave Management System (LMS) Employee Mobile Application is a Flutter-based mobile application that enables employees to manage their leave requests anytime and anywhere.

The application replaces manual leave application processes by providing a digital platform where employees can submit leave requests, track approvals, view leave balances, and manage their leave records.

---

## Features

### Authentication

- Secure employee login
- Firebase Authentication integration
- Role-based access control

### Leave Management

- Apply for leave
- Select leave type
- Choose start and end dates
- Provide leave reasons
- Add comments when necessary
- Upload supporting documents

### Leave Tracking

- View leave application status
- Track approved, pending, rejected, and cancelled requests
- View detailed leave information
- Get notified when leave is approved/rejected

### Leave History

- Access previous leave applications
- View approval outcomes
- Review leave records

### Leave Balance

- View available leave days
- Automatic leave balance updates
- Validation before leave submission

### Leave Application Management

- Edit pending leave requests
- Cancel pending leave requests
- Receive status updates

### Profile Management

- View personal information
- Update profile details



## Technology Stack

- Flutter
- Dart
- Firebase Authentication
- Cloud Firestore
- Firebase Storage


## Project Structure

```text
lib/
├── models/
├── services/
├── screens/
│   ├── login/
│   ├── dashboard/
│   ├── leave_application/
│   ├── leave_history/
│   ├── leave_details/
│   └── profile/
├── widgets/
├── utils/
└── main.dart



## User Flow

1. Employee logs into the application.
2. Employee views dashboard.
3. Employee submits a leave request.
4. System validates available leave days.
5. Request is sent for approval.
6. Employee tracks application progress.
7. Employee views leave history and balances.



## Functional Requirements

### Employee Login

Employees must be able to securely log into the application using valid credentials.

### Apply for Leave

Employees can:

- Select leave type
- Select leave dates
- Enter reasons
- Attach supporting documents

### View Leave History

Employees can view:

- Previous applications
- Application statuses
- Leave details

### Edit Leave Application

Employees can modify pending leave requests before approval.

### Cancel Leave Application

Employees can cancel pending leave requests.

### View Leave Details

Employees can view complete information about submitted leave requests.


### Security

- Secure authentication
- Protected employee data
- Role-based authorization


## Installation

### Clone Repository

```bash
git clone https://github.com/Ntombifuthi05/LeaveManagementSystem_Mobile_Application.git
```

### Install Dependencies

```bash
flutter pub get
```

### Configure Firebase

Add:

```text
android/app/google-services.json
```

and

```text
ios/Runner/GoogleService-Info.plist
```

### Run Application

```bash
flutter run
```
