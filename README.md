# Hacker News Client
This project is a hacker news client using their official api defined here: https://github.com/HackerNews/API

### Why this project?
This is a project that we had asked to our onsite interviews to our candidates and collaborated with them to solve while working at Mirror.

I am intentionally not using the optimized Firebase mobile clients for this project to showcase how I am overcoming the challenges while building this app. The API itself is extremely fast however requiring the client to make many api calls and maintain the app state internally.

If you are using charles or any network sniffer, you'd be seeing 10s of api calls are being made when you are opening a screen. Again, that's intentional.

### Architecture

The project is using SwiftUI to build the UI declaratively, and leverages MVVM as base architecture. Aside from that, it has a repository layer that is responsible of fetching and maintaining the data. 

The application has a single local package dependency called `Networking` which is providing the base functionality to make asynchronous calls. 

The project also uses Combine under the hood for the UI but for the rest of the areas leverages Swift Concurrency.

### Improvements

**Functional**
- Leverage AsyncStreams or Combine to stream the comments from the detail page instead of waiting comments to be fetched partially requested by the user.
- Implement infinite scrolling instead of on-demand pagination.
- In-Memory cache needs to be invalidated when needed.
- Optimize HTMLText view so that it doesn't throw warnings.
- Error handling is not properly done in this project.

**Architectural **
- Use a proper DI package such as Swinject or needle.
- Extract the high level pagination logic from view models.

**Testing**
- While the code is written testability in mind, there are currently no tests.

