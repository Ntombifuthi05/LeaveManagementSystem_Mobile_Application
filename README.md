# Leave Management System - Employee Mobile Application

## Overview

The Leave Management System (LMS) Employee Mobile Application is a Flutter-based mobile application that enables employees to manage their leave requests anytime and anywhere.

The application replaces manual leave application processes by providing a digital platform where employees can submit leave requests, track approvals, view leave balances, and manage their leave records.

##About

The Leave Management System Mobile Application is a cross-platform employee leave management solution developed using Flutter and Firebase. The application follows the MVVM (Model-View-ViewModel) architectural pattern to ensure a clean, scalable, and maintainable codebase.

Employees can securely log in, submit leave applications, track leave statuses, view leave history, and manage their profiles directly from their mobile devices. The system communicates with a centralized backend through RESTful APIs and Firebase services, enabling seamless data synchronization between the mobile and web platforms.

When an employee submits a leave request through the mobile application, the request is stored in the central database and becomes immediately available on the web application, where supervisors and HODs can review, approve, or reject the request. This real-time integration ensures efficient communication, faster decision-making, and accurate leave record management across the organization.

The project demonstrates modern software development practices, including cross-platform development, API integration, role-based access control, real-time data management, and the implementation of the MVVM architecture for improved separation of concerns and maintainability.

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

---

## Technology Stack

- Flutter
- Dart
- Firebase Authentication
- Cloud Firestore
- Firebase Storage

---

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
```

---

## User Flow

1. Employee logs into the application.
2. Employee views dashboard.
3. Employee submits a leave request.
4. System validates available leave days.
5. Request is sent for approval.
6. Employee tracks application progress.
7. Employee views leave history and balances.

---

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

---

## Non-Functional Requirements

### Performance

Fast response times for leave submissions and data retrieval.

### Security

- Secure authentication
- Protected employee data
- Role-based authorization

---

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

---

## Future Improvements

- Push notifications
- Dark mode
- Offline support
- Biometric authentication
- Leave calendar integration

---



