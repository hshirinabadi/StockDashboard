# Stock Dashboard

A stock dashboard iOS application powered by the Finnhub.io API that allows users to search for companies, view its current and historical price data, see company profiles, and read the latest related articles.

## Screenshots

[Add screenshots or GIFs of the app here]

## Features

### Core Features
- Stock Search: Search for companies by name or ticker symbol
- Current Quote: Display current price, daily change percentage, and high/low prices
- Company Profile: Show company name, logo, industry, exchange, and market cap
- Latest News: View recent news articles with headlines, sources, and dates
- News Article Opening: Tap on an article to open it in Safari


## Setup Instructions

### Requirements
- iOS 16.6+
- Xcode 14.0+
- Swift 5.0+

### Installation
1. Clone this repository
```bash
git clone https://github.com/hshirinabadi/StockDashboard.git
```

2. Open the project in Xcode
```bash
cd StockDashboard
open StockDashboard.xcodeproj
```

3. Add your Finnhub API Key

   This project requires setting your Finnhub API key as an environment variable:
   
   ```bash
   # Set API key
   export FINNHUB_API_KEY=your_api_key_here
   
   # Then run Xcode
   open StockDashboard.xcodeproj
   ```
   
   You can also add your API key directly in Xcode from Product -> Scheme -> Edit Scheme -> Environment Variables.

4. Build and run the application on the iOS Simulator or physical device

## Architecture

### Pure MVVM Architecture with State-Based Reactive UI
This project follows a sophisticated MVVM architecture with state-based reactive UI:
- **Model**: Domain models and immutable UI state objects
- **View**: Self-contained UI components reactively binding to state streams
- **ViewModel**: Single source of truth that publishes state changes
- **Controllers**: Ultra-thin wiring layer with minimal responsibilities

### Advanced Reactive State Management
- True unidirectional data flow with published state objects
- Publisher/subscriber pattern for direct view-to-state binding
- Clean separation of concerns with no ViewModel knowledge in the View layer
- Swift's async/await for efficient networking
- Task management for proper cancellation and lifecycle control
- Centralized ViewState management for completely predictable UI behavior
- Closure-based callbacks for simplified event handling

### Protocol-Based Design
- Protocol-oriented design for better testability and flexibility
- Dependency injection for easier unit testing

## Notable Implementation Details

### Networking Layer
- Modern async/await networking layer for API requests
- Swift structured concurrency with proper task management
- Comprehensive error handling and response parsing

### UI Implementation
- Fully programmatic UI without storyboards
- Responsive layouts with Auto Layout
- Support for light and dark mode
- Custom views with clear separation of concerns
- Adaptive collection view layouts for different screen sizes

### Search Experience
- Debounced search queries for better performance
- Modern collection view display with card-style results
- Visual feedback with shadows and rounded corners
- Smooth transitions and animations

## Shortcuts and Future Improvements

- No unit or UI tests are implemented. A production app would include comprehensive test coverage.
- Limited error handling UI. More granular error states could be added for various failure scenarios.
- Stock price is updated using a polling mechanism. A production would use SSE or WebSockets to display real-time price update (Too much over-head for this project).

## Open Source Libraries

This project doesn't use any external dependencies to keep it simple and demonstrate pure Swift development skills.
