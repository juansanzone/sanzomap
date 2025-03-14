

# Juan Sanzone - Mobile Challenge

## 👋 Intro

The following `README` explains how the functional requirements from the attached **Mobile Challenge - v0.7.pdf** were implemented.

During the previous evaluation stage, the interviewers asked me to focus on architecture points rather than implementation details for this challenge. But, I decided to complete both aspects.

This `README` provides an overview of the architecture and details on how the proposed feature was implemented.

You can find a breakdown of the roadmap **(Kanban)** used to divide tasks for this challenge at [this link](https://github.com/users/juansanzone/projects/1/views/1).


## 📲 Minimum Requirements
- **Xcode 15.4** or higher
- **iOS 17.6** or higher
```
 ℹ️ Latest versions of Xcode and iOS are supported. The project was tested on iOS 18 and Xcode 16.2 without any issues.
```

## 🐒 How to Install/Run?

### Clone the repository
```
1. git clone git@github.com:juansanzone/sanzomap.git
```

### Open project
```
1. Open folder -> sanzomap/App
2. Open file -> SanzoMap.xcodeproj
```

Wait for SPM to load the local packages, select your simulator and 🚀 !!


## 👷🏼‍♂️ Architecture

A modular and independent architecture was developed.

The goal was to achieve a pragmatic balance, avoiding unnecessary complexity while ensuring scalability in the medium term. This approach considers a hypothetical scenario where the project grows or the team expands.

**UI & Feature Architecture**: SwiftUI was used for all views, including the ***Map screen***. A simple but structured **MVVM** was implemented at the Feature level.
A protocol was created to standardize **VM** implementation across Features modules, ensuring consistency.

**Navigation**:  SwiftUI navigation was standardized using a **Router** based on NavigationPath. This provides a solid foundation for navigation inside Feature modules. More details about this approach are covered in the Navigation section.

Several Swift Packages were created to serve as a foundation for developing Features.

### 📦 Architecture Components

#### 📦 CORE Package

#### ⚙️ Networking
A simple network client that provides a network service for making API calls and processing objects. It handles:

- Basic error management
- Different HTTP methods
- Base URL and headers

This client is primarily used by the **Services layer**, ensuring a standardized way to make network requests.

```
The current internal implementation is very basic, designed only to fulfill the challenge requirements. 

It doesn't support:
- Multiple environments
- Session management
- Complex headers
- An attempt was made to handle the Cache-Control header, but it was unsuccessful 
because the GIST URL provided in the challenge does not support cache control.
```
---
#### ⚙️ Foundation
The goal of this logical separation is to provide standardized components that help teams maintain consistency in development. These components focus on the foundations of the project and how to handle key aspects.

**Included Components**

- **DataState**: Represents different states like loading, error, and data loaded.
- **Logger**: A standardized logging component. This could become a separate package in the future, but for now, it remains simple. This supports log system level configuration.

![image](https://github.com/user-attachments/assets/ff7d1861-798b-4d77-ad81-1725bb045f20)

```
The log level is set in debug mode during app initialization on the main onAppear().
Allows adding a listener to capture events for future backend logging 
(e.g., Datadog or other remote storage services).
For this challenge, the listener is not implemented and remains null.
```
---

#### ⚙️ Architecture

The goal of this logical separation is to provide components that guide the project's architecture. For this challenge, two core components were defined:

- **NavigationRouter**: A protocol designed to standardize navigation in SwiftUI. ***Why?*** SwiftUI navigation is not very scalable and is often tightly coupled to the View. This component provides a more imperative approach (UIKit-style) with better control. It is fully designed for SwiftUI, but minor adjustments could allow UIKit-based navigation if needed. In some projects where navigation is 100% UIKit-based, this component may not be necessary. For this challenge, it serves as a simple and standardized way to handle SwiftUI navigation, keeping it decoupled from Views.

- **ObservableViewModel**: A standardized way to implement MVVM in a structured way.***Why?** Not because it is the "best" way, but to ensure consistency across teams. Keeps MVVM simple, allowing smooth SwiftUI integration. This introduces some TCA arch inspired concepts like -> Single source of truth for state management and action handling for a clear flow. Does not include advanced features like side effects or action chaining. This component provides a solid foundation for a well-structured MVVM architecture.

---
#### 📦 COREUI Package

This package serves as the shared UI library, containing the system design components.

Some Included Components are 👇
- ***List Row***: Used in the cities screen.
- ***Error Message View***: A reusable component for displaying errors with a retry option.
- ***Skeleton List View***: A placeholder UI for loading states.
- ***Spacing Standardization***: A CGFloat unified approach for handling paddings and spacing.

```
This is the only package without Unit Tests, as it does not make sense to test UI components
in this context. It could be tested using snapshot tests or similar approaches,
but for this challenge, no tests were added.
```
---
#### 📦 SERVICES Package

This package contains the shared services used by Feature teams. It is possible to create a separate package for each service, but that is a team decision. For now, adding that overhead is not necessary. Just to avoid early optimizations.

- ***CityService***: It handles the request to the remote GIST file provided in the challenge and its associated DTO.

---
#### 📦 MapFeature Package [FEATURE MODULE]
This package is intended to be a Feature module, which is why it is located in the Features folder in the filesystem.

It could represent a specific team's module responsible for managing the cities flow. (?)

- ***CityListView***: The city list view where users can search and filter cities.
- ***MapCityView***: The view that displays the map for the selected city.
- ***MapFeatureRouter***: The router that handles navigation within the feature flow.
- ***CityRepository***:
    - Connects to the cities service.
    - Fetches the city list from the network.
    - Use SwiftData to persist the city list
    - Filters and searches results
- ***City***:
    - The model object used in the view to represent a City.
    - Also used for persisting the City list and storing its favorite state.

```
This package contains the entire solution for the challenge,
which will be discussed in depth detail later 😏
```
---

## 👨🏻‍⚕️ Unit tests ?
All packages include Unit Tests, except for the CoreUI package.
For sure.. the most important tests are in ***CityRepositoryTests***, as they cover the search functionality, which was explicitly required in the challenge document.

#### [Core tests]
![image](https://github.com/user-attachments/assets/ce80582e-c57e-4b59-9612-78c395af9d33)

#### [Services tests]
![image](https://github.com/user-attachments/assets/e59d0212-546d-4713-a62e-6a2528857721)

#### [Feature tests]
![image](https://github.com/user-attachments/assets/a26a6d29-2232-4118-b112-b94a47aaec94)


### 💥 Memory Managment + Stress test
Without doubt... the first launch, where cities are fetched and sequentially stored in SwiftData, is the moment of highest CPU and memory consumption. However, during this process, the app is in a waiting state.

After this initial setup, CPU and memory usage return to normal. This only happens once per install, since on subsequent launches, the cities are already stored on the device, making the startup time instant with no additional memory consumption.

***Memory & Performance Observations:***

The app runs without memory leaks and maintains stable memory usage.
Exception: The SwiftUI Map (MapKit) component has high memory consumption and some leaks. This is a known MapKit issue with SwiftUI, not related to our implementation. Memory usage increases in landscape mode, where both the map and city list are displayed at the same time.

![image](https://github.com/user-attachments/assets/a8605396-8d3e-435e-9e34-495f1dd586c2)


---

### 📝 Functional basic requirements
- Fetch cities from remote Gist file ✅
- Show list of cities ✅
- Show city details with a Map view ✅
- Allow search by prefix based on document criteria ✅
- Favorite / remove from favorites feature ✅ - (Swipe cell to fav/unfav)
- Stored locally for Favorite feature (remains on each app launch) ✅
- Filter by Fav / unfav ✅
- Landscape and portrait designs support ✅
- Unit test ✅
- Readme ✅
- Automation UI tests 🔴 - I didn't have time

### 😎 Extra Features
- 🎁 Save cities locally (remains on each app launch)
- 🎁 Error view with retry for network fetch
- 🎁 Skeleton loading state view
- 🎁 Instant ultra-fast app start after the second app start. Since the cities are already stored on the device


### 🤓 How did I solve the search?
The initial approach I wanted to implement was a direct-access hash for ***City*** names. This would have provided `O(1)` complexity with instant lookups.

But, since the search required prefix matching, this solution was impossible or complicated. Generating direct keys for prefix variations was not easy. Additionally, while 200k records could fit in memory (maybe!).. we would be at the limit. This approach does not scale well for the future since we depend on an external service, and we cannot predict how the dataset might grow.

Since prefix search was required and a simple in-memory index was not an option, I decided to use SwiftData. Because it internally handles indexes, allowing fast and efficient prefix-based searches. Also it persists cities, making future app launches instant without refetching data and it enables reusing the same model to store favorite/unfavorite states and apply filtering.

You can find the solution in action inside `CityRepository` object.

### 🐛 Unhappy points

1️⃣
I'm not fully satisfied with how landscape/portrait handling was implemented. While the product looks and works well, I would have preferred to use Split Navigation View, letting the system decide when to switch layouts.

***Why didn't I Use Split View?***

The design required a split-screen layout in landscape mode for iPhone.
SwiftUI's Split View does not behave as expected on iPhone—it is primarily designed for iPad.
Due to this design limitation, I had to implement a workaround to manage landscape/portrait while staying as close as possible to the proposed design.
However, the design does not follow Apple's native patterns or align with the available SwiftUI components.
For iPad, I did not use preprocessor macros or special cases, as it seemed unnecessary for this challenge. This could be improved in future iterations.

2️⃣
I did not add unit tests for the main ViewModel due to lack of time.
However, I believe the most important tests were the ones explicitly requested, which are already covered in `CityRepository`.

### 🖼️ App screens
#### Portrait
|Loading|List|Map|
|-|-|-|
|![image](https://github.com/user-attachments/assets/f6293100-e278-4cc0-b725-2709fd47b90c)|![image](https://github.com/user-attachments/assets/e68f6564-33de-4c4b-9bc3-812b7e9b1049)|![image](https://github.com/user-attachments/assets/2e16c8e3-7fa7-4b01-a61d-2cd340f1a495)|

|Fav filter|Fav|Unfav|
|-|-|-|
|![image](https://github.com/user-attachments/assets/06697975-b6f2-483f-8440-0ce85d3d2025)|![image](https://github.com/user-attachments/assets/d6391643-289d-4bf0-aff2-50c66ca48765)|![image](https://github.com/user-attachments/assets/9d2d4a81-873e-4c1f-89e2-b35e890016ac)|




#### Landscape
|Map + List|
|-|
|![image](https://github.com/user-attachments/assets/b44efd25-25c7-4ec3-951d-df1c9d7f7402)|
