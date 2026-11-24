# DuoLeic Development Report

Welcome to the documentation pages of the DuoLeic!

Here you can find details about the DuoLeic, from a high-level vision to low-level implementation decisions, a kind of Software Development Report, organized by type of activities:

* [Business modeling](#Business-Modelling)
    * [Product Vision](#Product-Vision)
    * [Features and Assumptions](#Features-And-Assumptions)
* [Requirements](#Requirements)
    * [Domain Model](#Domain-Model)
* [Architecture and Design](#Architecture-And-Design)
    * [Logical Architecture](#Logical-Architecture)
    * [Physical Architecture](#Physical-Architecture)
    * [Vertical Prototype and Increments](#Vertical-Prototype-And-Increments)
* [Project Management](#Project-Management)

Contributions are expected to be made exclusively by the initial team, but we may open them to the community, after the course, in all areas and topics: requirements, technologies, development, experimentation, testing, etc.

Please contact us!

Thank you!

* Eduardo Cruz - up202205138@up.pt
* Gonçalo Pinto - up202204943@up.pt
* José Granja - up202205143@up.pt
* Leonardo Ribeiro - up202205144@up.pt
* Tomás Costa - up202205152@up.pt

---
## Business Modelling

### Product Vision
For second year L.EIC students who want to improve their grades,
the DuoLeic is a productivity and self-development app that makes
studying  easier  than ever by gamifying it and making it enjoyable.
Unlike other apps, our product makes learning and consolidating
subjects fun by giving incentives and rewards for daily study.

### Features and Assumptions

#### Features
* Ability to choose a specific topic to study within an UC.
* Daily streak counter that resets if the user doesn't study that day.
* Streak Saver that, if in the inventory, is used and lost to prevent the end of the streak if the user fails to study one day.
* Quizzes and Flash Cards of each UC for the user to study.
* Different levels of difficulty in each UC that can be unlocked by the user.
* Achievements for the user to reach.
* User Profile where the achievements, progress and friends list are available for the user to see.
* Ability to see your friend's profile.

#### Dependencies
* Current Date and Time (Google API) for study streak verification
* Firebase Authentication for user authentication and registration
* Firebase FireStore for storing user data, achievements, quizzes and flashcards

## Requirements

### Domain Model 

Our domain model gives an overview of the most important parts of our project and serves as a reference for other developers to understand how our project is structured.

![ClassUML](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC10T1/assets/121761493/13008cf7-c06b-437d-8f8e-e4e7b34ddf2a)


## Architecture and Design

#### Overall Components
1. Presentation:
   - Responsible for handling user interactions.
   
2. Application:
   - Contains the logic of the system.

3. Data:
   - System data related to the users (firebase).

4. Integration:
   - Communication google data time api to get external data.

#### Problems
1. Problems linking with firebase:
   - Resolved.
   
2. Problems running acceptance tests:
   - Not resolved yet.
   
3. Problems with full unit test coverage:
   - Not resolved yet.

### Logical Architecture 

Our package UML delineates the layer between our application and the external service google data time services that we are using and were not done by us.

![PackageUML](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC10T1/assets/121761493/d06c5e3f-c610-425b-a102-aae3cb40bf6c)

### Physical Architecture 

The physical architecture of our program is designed to ensure the efficient deployment and scalability across the environments.

Deployment nodes and artifacts:

1.User client phone
   - Represent the end-user devices (smartphones) with android OS
   - Artifacts: APP (Android APK)

2.Database
   - Stores all the information about settings, log in credentials, ucs and settings. 
   - Artifacts: Firebase

3.Google Server (API)
   - Handle data time
   - Artifacts: Google Data Time (API)


![deployment drawio](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC10T1/assets/133802685/90dca448-e15e-4fe4-abf9-e23f7aac3432)


### Vertical Prototype and Increments
[Click here](CHANGELOG.md)


## Project Management 
You can find below information and references related with the project management in our team:

* Backlog management: Product backlog and Sprint backlog in a [Github Projects board](https://github.com/orgs/FEUP-LEIC-ES-2023-24/projects/77);
* Release management: [v0](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC10T1/releases/tag/Primeira_Entrega), [v1](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC10T1/releases/tag/Segunda_Entrega), [v2](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC10T1/releases/tag/Terceira_Entrega), [v3](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC10T1/releases/tag/Entrega_Final);
* Sprint planning and retrospectives:
    * [Iteration 0](docs/iteration0.md)
    * [Iteration 1](docs/iteration1.md)
    * [Iteration 2](docs/iteration2.md)
    * [Iteration 3](docs/iteration3.md)
