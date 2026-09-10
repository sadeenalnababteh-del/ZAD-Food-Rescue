1- ZAD-Food Rescue Application 

-Stop Wasting. Help the Community!
-ZAD is a food rescue application built on the Flutter platform. This app is meant to help minimize the amount of wasted food via connections between food donors, charity organizations, and volunteers.
-The ZAD project offers a system that helps control and facilitate the food donation process


2-Project Summary

-Every single day, restaurants, hotels, grocery stores, and other food service organizations could potentially have surplus food that is still good to consume.

-ZAD wants to be the digital tool that would enable these excess foods to be directed to charities that can then make these available to those who need them, helping volunteers deliver at the same time.

-There are three primary roles for users of the platform:

i-Provider – Food donation creator and manager.
ii-Charity/Receiver – Donation discovery and claimer.
iii-Volunteer – Delivery task manager and verification.


3-Goals

-Decrease unnecessary food wastage.
-Establish linkages between surplus food suppliers and charity groups.
-Make the process of food donation management efficient and transparent.
-Help volunteers in organizing deliveries.
-Measure the social and environmental impact of donated food.


4-Key Features: 

i) Authentication
 -Registration and user login.
 -Authentication through email/password.
 -Onboarding based on roles.
 -Users' information stored in Firebase.


ii) Provider Dashboard

Providers can:

-Monitor donation statistics.
-Create new food donations.
-Manage their donations.
-Monitor donation status.
-Monitor donation details.


iii) Charity / Donor

Receivers are able to:

-Look at available food donations.
-Look at priority donations.
-Look into donation information.
-Claim available donations.
-Monitor their donations received.


iv) Donation Finding

-Interactive donation map.
-Pins for donation location.
-Filtering options.
-Information about donation from chosen location.


v) Volunteer Delivery Management

Volunteers can:

-Check their delivery tasks.
-Check delivery status.
-Navigate to donation location.
-Check if deliveries have been made.
-Report safety issues if necessary.


vi) Impact and Sustainability

Apart from that, ZAD also offers:

-Food rescue impact.
-Community impact.
-Sustainability measures.
-Sector impact.
-Visual impact stats.


vii) Profile & Leaderboard

Users are able to see the following:

-Profile info.
-Progress.
-Points.
-Badges & achievements.
-Leaderboard position.
-Impact stats.


5- Technology Stack

Technology	        Usage
_________________________________________________________________
Flutter	            Cross-platform mobile application development

Dart	            Application programming language

Firebase 
Authentication	    User authentication

Cloud Firestore	    Cloud database and real-time data

Google Fonts	    Typography and Inter font

Material Design	    UI components and design system


6-Project Structure

lib/
│
├── main.dart
│
├── screens/
│   ├── welcome_screen.dart
│   ├── login_screen.dart
│   ├── app_shell.dart
│   ├── provider_dashboard_screen.dart
│   ├── receiver_dashboard_screen.dart
│   ├── donation_details_screen.dart
│   ├── find_donations_map_screen.dart
│   ├── my_donations_tracker_screen.dart
│   ├── my_delivery_tasks_screen.dart
│   ├── navigate_verify_delivery_screen.dart
│   ├── safety_incident_log_screen.dart
│   ├── profile_leaderboard_screen.dart
│   └── global_sustainability_impact_screen.dart
│
├── services/
│   └── firebase_service.dart
│
├── theme/
│   └── app_theme.dart
│
└── firebase_options.dart



7-Firebase Integration

ZAD integrates Firebase as backend infrastructure.

-Firebase Authentication

    Firebase Authentication is implemented for handling user sign up and sign-in through email and password authentication.

-Cloud Firestore

    i)Cloud Firestore is used for storing data related to applications, such as user data and data related to food donations.
    ii)The application also integrates real-time streams of Firestore for keeping information relevant to the application up to date.



8- Application Flow


                    ┌─────────────────┐
                    │   ZAD Platform  │
                    └────────┬────────┘
                             │
             ┌───────────────┼───────────────┐
             │               │               │
             ▼               ▼               ▼
        ┌──────────┐   ┌──────────┐   ┌──────────┐
        │ Provider │   │  Charity │   │ Volunteer│
        └────┬─────┘   └────┬─────┘   └────┬─────┘
             │              │              │
             ▼              ▼              ▼
       Create & Manage   Discover &     Manage &
         Donations        Claim          Deliver
             │              │              │
             └──────────────┼──────────────┘
                            ▼
                   ┌─────────────────┐
                   │ Rescued Food    │
                   │ Reaches People  │
                   │ in Need         │
                   └─────────────────┘

9- Application Screens

The application has dedicated screens for:

-Welcome & authentication
-Provider dashboard
-Receiver dashboard
-Donation details
-Donation map
-My donations tracker
-Delivery tasks
-Delivery navigation & verification
-Safety incident reporting
-Profile & leaderboard
-Global sustainability impact


10- Design

ZAD utilizes an elegant and modern design that centers on usability and accessibility.

ZAD has:

-Green as its primary color.
-Card based design layout.
-Equal spacing and round shapes.
-Inter fonts.
-Material Design elements.
-Role-based dashboards.


11- Getting Started

Prerequisites

Make sure you have the following installed:

-Flutter SDK
-Dart SDK
-Android Studio or VS Code
-A configured Firebase project
-Installation

Clone the repository:

git clone https://github.com/sadeenalnababteh-del/ZAD-Food-Rescue.git

-Navigate to the project:

-cd ZAD-Food-Rescue

-Install dependencies:

-flutter pub get

-Run the application:

-flutter run


12- Firebase Configuration

Before running the app, ensure that your Firebase project is configured correctly.

This project uses the following services:

- Firebase Authentication
- Cloud Firestore

For security purposes, don’t add private credentials, service account files, or any other sensitive configuration files in the public repository.


13- Academic Project

-ZAD is a project created as part of a university course in software engineering, with the idea of utilizing the knowledge about software development in practice to solve an actual social and environmental issue.

-The project involves mobile application development, cloud computing, databases management, authentication, UI/UX designing, and role-based workflows in one product.



14- My Contributions

My contributions to the project include the development of the following aspects of the ZAD mobile application:

-Flutter UI development.
-Application navigation.
-Firebase Authentication integration.
-Cloud Firestore integration.
-Donation management functionalities.
-Role-specific application screens.
-Delivery and tracking workflows.


15- Vision

-ZAD envisions how technology can be leveraged to bridge the gap between food vendors, charitable institutions, and volunteers for a more streamlined food rescue experience.

-Less wastage. More effect. A better community.


16- Project Status

-Version: 1.0.0
-Platform: Flutter / Android
-Backend: Firebase
-Status: Academic Project / Portfolio Project


17- License

The following project is intended for education and portfolio use.
