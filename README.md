# ReliefLink


## Direct Disaster Relief Fund Distribution Mobile Application
### Team Name: TriAce


### Team Members
- Member 1: Anakha RA - TKMCE
- Member 2: Arya Rajeev - TKMCE
- Member 3: Anna Tomson - TKMCE

### Hosted Project Link
https://drive.google.com/file/d/1nCvgSF20r-2DX_IMCg6eKNeo2JYxfNFu/view?usp=drive_link

### Project Description
The ReliefLink mobile application connects donors directly with disaster-affected individuals, bypassing intermediaries to promote transparency and efficiency. It provides real-time updates on camp needs, enabling donors to contribute targeted resources, and utilizes an impact factor to prioritize aid for the most vulnerable. By streamlining the distribution process, ReliefLink ensures equitable support and empowers donors to make meaningful contributions to disaster recovery efforts.

### The Problem statement
Current disaster relief systems often rely on government intermediaries to distribute funds, leading to inefficiencies and potential corruption. This can result in some individuals receiving aid while others, equally in need, do not. To address these issues, this project proposes a mobile application that facilitates direct transfers from donors to those in need, bypassing intermediaries and ensuring that aid reaches the intended recipients.

### The Solution
ReliefLink serves as a bridge between donors and disaster-affected individuals, enabling targeted, transparent, and effective aid distribution while maintaining privacy. The app features two core functionalities: Immediate Camp Needs, where volunteers update real-time camp requirements based on resident demographics, allowing donors to provide swift and precise support, and Post-Camp Support, which focuses on helping individuals rebuild their lives by identifying primary needs like shelter and healthcare and assessing vulnerabilities such as age, health, and financial loss.

To ensure fair prioritization, the app uses an Impact Factor, a weighted score calculated from parameters such as medical emergencies, shelter needs, and income loss. This dynamic system continuously updates and sorts beneficiaries, allocating donations in real time to those most in need. Donor and recipient identities are kept confidential, with donors able to track how their contributions are used, ensuring transparency while respecting privacy. ReliefLink empowers donors to make meaningful contributions and supports sustainable recovery efforts for disaster-affected individuals.

## Technical Details
### Technologies/Components Used
For Software:
- Dart
- Flutter
- Built-in Dart/Flutter Libraries: package:flutter/material.dart
- 1. Flutter SDK
  2. IDE/Code Editor:   1. Android Studio   2. Visual Studio Code   3. Intellij IDEA
  3. Dart Compiler


### Implementation
For Software:

# Installation
1. Install Dependencies:
   - Frontend (Flutter): flutter pub get
     
2. Setup Firebase:
   - Create a Firebase project and download the google-services.json (for Android)
   - Place the files in the appropriate directories: android/app for google-services.json
     
3. Configure Environment Variables:
   - Create a .env file for backend configurations.
     - FIREBASE_API_KEY=your_api_key
     - DATABASE_URL=your_database_url
     - SECRET_KEY=your_secret_key

# Run
1. Frontend:
    - Run the Flutter app on an emulator or physical device: flutter run
      
2. Emulator Setup:
   - Launch the Android emulator if required:
     - flutter emulators --launch <emulator_id>
     - flutter run

### Project Documentation
For Software:
Screens
1. Home Screen:
Overview of campaigns, user role selection, and donation progress.

2. Immediate Camp Needs Screen:
Live updates of disaster-affected areas and specific requirements.

3. Post-Camp Support Screen:
List of individual recovery needs with prioritized Impact Factors.

4. Donation Screen:
Secure payment gateway for processing contributions.

5. Profile Screen:
User information, role-specific features, and donation history.

6. Login/Signup Screen:
User authentication and account creation.

7. Donation History Screen:
Display a list of past donations made by the user.

8. Transaction Enquiry Screen:
Provides information about a specific transaction, including legal details of the recipient and the allocation of funds. 

# Screenshots 

![Alt text ](https://github.com/AnnaTomson/ReliefLink/blob/main/images/home.jpg)

The Home Screen provides easy navigation to key features of the app:

Donor Page: Access to donate items or money for disaster relief efforts.
Volunteer Page: Options to add camp requirements or people to camps and track their impact.
Sidebar Menu: Quick links to History, Transaction Enquiry, and Payment for In-Trend Disasters.
The Home Screen serves as the central hub, offering seamless access to donation, volunteering, and tracking, ensuring users can efficiently contribute and stay informed

![Alt text](https://github.com/AnnaTomson/ReliefLink/blob/main/images/addperson.jpg)

The Add People page allows volunteers to add individuals to disaster relief camps. For each person added:

Input Details: Volunteers fill in necessary information such as name, age, and specific needs.
Impact Factor Calculation: The system calculates an Impact Factor based on the details provided, helping prioritize assistance and track the overall impact.
This feature ensures a data-driven approach to resource allocation, optimizing aid distribution based on the needs of each individual.

![Alt text](https://github.com/AnnaTomson/ReliefLink/blob/main/images/requirements.jpg)

The Camp Requirement screen allows volunteers to add specific needs for disaster relief camps, which are then displayed to donors for contribution. Volunteers can:

Add Requirements: List essential items needed for the camp, including quantity and urgency.
Update/Remove Items: Modify or remove requirements as needs change.
Display to Donors: Requirements are visible to donors, enabling targeted donations.
This feature ensures optimized resource collection and distribution, streamlining aid efforts by matching donations with immediate needs.

![Alt text](https://github.com/AnnaTomson/ReliefLink/blob/main/images/transaction.jpg)

The Transaction Enquiry page ensures transparency in donations. Users can:

View Donation History: See details of past donations, including amounts and destinations.
Check Status: Track the current status of donations (processed, pending, etc.).
View Impact: Understand how the donations were used and their impact.
Receiver Information: Access details about the recipient camps or organizations.
This page builds trust by providing clear, accountable insights into the donation process.

# Diagrams
![Alt text](https://github.com/AnnaTomson/ReliefLink/blob/main/images/workflow.jpg)

Login Screen
- New User: If the user is new, they can navigate to the *Sign-Up Screen*.
- Existing User: If the user is already registered, they can log in and proceed to the *Home Screen*.

Home Screen
Once authenticated, the user is taken to the Home Screen, which contains four primary navigation options:
1. Sidebar Menu:
   - Profile: Access user profile information.
   - History: View the history of past donations and interactions.
   - Transaction Enquiry: Check the status of donations or volunteer activities.

2. Donation to Leading Disaster: This option allows the user to donate to a disaster relief effort or leading disaster initiatives.

3. Volunteer Screen: 
   - Add Camp Requirement:
     - Users can add the required items for disaster camps, along with their urgency and quantity. If necessary, they can also delete requirements.
   - Add People to the Camp:
     - Users can add individuals to camps and calculate the *Impact Factor*, which helps prioritize assistance and track the number of people impacted.

4. Donor Screen: 
   - Camp Help:
     - Users can donate the required items for a specific camp based on current needs.
   - Post Camp Help:
     - Users can directly make monetary donations to support post-camp initiatives or further relief efforts.


### Project Demo
# Video
https://drive.google.com/file/d/1nCvgSF20r-2DX_IMCg6eKNeo2JYxfNFu/view?usp=drive_link

Login Screen
- New User: If the user is new, they can navigate to the *Sign-Up Screen*.
- Existing User: If the user is already registered, they can log in and proceed to the *Home Screen*.

Home Screen
Once authenticated, the user is taken to the Home Screen, which contains four primary navigation options:
1. Sidebar Menu:
   - Profile: Access user profile information.
   - History: View the history of past donations and interactions.
   - Transaction Enquiry: Check the status of donations or volunteer activities.

2. Donation to Leading Disaster: This option allows the user to donate to a disaster relief effort or leading disaster initiatives.

3. Volunteer Screen: 
   - Add Camp Requirement:
     - Users can add the required items for disaster camps, along with their urgency and quantity. If necessary, they can also delete requirements.
   - Add People to the Camp:
     - Users can add individuals to camps and calculate the *Impact Factor*, which helps prioritize assistance and track the number of people impacted.

4. Donor Screen: 
   - Camp Help:
     - Users can donate the required items for a specific camp based on current needs.
   - Post Camp Help:
     - Users can directly make monetary donations to support post-camp initiatives or further relief efforts.


## Team Contributions
- Anna: Login Screen, Donar Screen, Add People, Search
- Arya: Payment and SignUp screen, Camp Details, Donation History, Transaction Details
- Anakha: Enquiry and Volunteer, Impact Factor, History Navigation, Navigation, Requirements Delete, Help

---
Made with ❤️ at TinkerHub by TriAce
