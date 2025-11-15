

# Stock Dashboard

A stock dashboard iOS application powered by the Finnhub.io API that allows users to search for companies, view their current price data, see company profiles, and read the latest related articles.

## Screenshots/GIFs

<img src="app_demo.gif" width="400" alt="App Demo" />

## Features

### Core Features

- **Stock Search**: Search for companies by name or ticker symbol with debounced queries.
- **Stock Selection**: Selecting a result navigates to a dedicated dashboard for that company.
- **Current Quote**: Display current price, daily percentage change, and intraday high/low prices.
- **Company Profile & Key Stats**: Show company name, ticker, logo, industry, exchange, market cap, and P/E ratio (where available).
- **Latest News**: View recent news articles with headline, source, date, and thumbnail.
- **Open in Safari**: Tapping a news article opens it in Safari.

## Setup Instructions

### Requirements

- iOS 16.6+
- Xcode 14.0+
- Swift 5.0+

### Installation

1. **Clone this repository**

```bash
git clone https://github.com/hshirinabadi/StockDashboard.git
```

2. **Open the project in Xcode**

```bash
cd StockDashboard
open StockDashboard.xcodeproj
```

3. **Add your Finnhub API Key**

This project reads the Finnhub API key from the `FINNHUB_API_KEY` environment variable. You can provide this key in one of two ways:

1. **Via Xcode Scheme (recommended)**  
   - Open `Product` → `Scheme` → `Edit Scheme…`  
   - Under `Run` → `Arguments`, add an Environment Variable:  
     - Name: `FINNHUB_API_KEY`  
     - Value: `<your_api_key_here>`

2. **Via terminal environment**

```bash
# Set API key
export FINNHUB_API_KEY=your_api_key_here

# Then run Xcode
open StockDashboard.xcodeproj
```

4. **Build and run** the application on the iOS Simulator or a physical device.

## Architecture

### Pure MVVM Architecture with State-Based Reactive UI

This project follows an MVVM architecture with a state-driven, reactive UI:

- **Model**: Domain and API models that mirror Finnhub data and app domain concepts.
- **ViewState**: Typed structs that represent a snapshot of all UI state for a screen and are mutated only inside the ViewModel.
- **View**: Self-contained UI components that render purely from the current view state and bind to its publishers.
- **ViewModel**: Single source of truth that owns view state, performs business logic and async work, and exposes state as publishers.
- **Controller**: Ultra-thin wiring layer responsible only for navigation and wiring views to view models.

### Reactive State Management

- **Unidirectional data flow**: User interactions flow into the ViewModel; the ViewModel publishes updated state; Views render based on that state.
- **Published state objects**: Observable state properties expose view state streams that Views can subscribe to.
- **Combine-based bindings**: Views subscribe to ViewModel publishers; the View layer does not know about concrete ViewModel types.
- **Async/await networking**: All network calls use Swift async/await with structured concurrency.
- **Task lifecycle management**: Search requests and polling tasks are cancellable and tied to the screen lifecycle.
- **Centralized view state**: Each screen has a single state object that drives all UI rendering and view sections.

### Protocol-Based Design

- **Service abstraction**: A protocol-based service layer abstracts calls to the networking layer.
- **Dependency injection**: View models depend on service protocols instead of concrete implementations, which makes them easy to mock and test.
- **Loose coupling**: The networking layer is isolated from UI and view state behind clear protocol boundaries.

### Project Structure (High Level)

- `Networking/`
  - `FinnhubAPIClient.swift`, `FinnhubErrors.swift`, `FinnhubModels.swift`
- `Services/`
  - `StockService.swift`, `StockServiceProtocol.swift`
- `StockSearch/`
  - `ViewControllers/StockSearchViewController.swift`
  - `ViewModels/StockSearchViewModel.swift`, `StockSearchViewState.swift`
  - `Views/StockSearchView.swift`, `SearchSymbolCollectionViewCell.swift`
- `StockDetail/`
  - `ViewModel/StockDetailViewModel.swift`, `StockDetailViewState.swift`
  - `ViewControllers/StockDetailViewController.swift`
  - `SectionControllers/*`
  - `Views/StockDetailView.swift`, `StockDetailCells/*`
- `Config/Configuration.swift`
- `CommonViews/` (loading, empty, error states)

## Notable Implementation Details

### Networking Layer

- Modern async/await networking layer for all Finnhub API requests (`FinnhubAPIClient`).
- Swift structured concurrency with proper `Task` management and cancellation.
- Simple, centralized error handling via `FinnhubError` and HTTP status code checks.

### UI Implementation

- Fully programmatic UI (no storyboards) using Auto Layout constraints.
- Responsive layouts that adapt to different screen sizes.
- Support for both light and dark mode via system colors.
- Custom collection view cells for search results and detail sections with clear separation of concerns.
- Pluggable section-based detail screen that composes header, quote, company info, key stats, and news.

### Search Experience

- Debounced search queries (0.5s) to avoid spamming the API as the user types.
- Cancellation of in-flight search requests when the query changes.
- Modern collection-view-based results list with card-style presentation.

### Stock Detail Page

- Concurrent loading of quote, company profile, and news using `async let` for a responsive first render.
- Flexible section architecture (`StockDetailSection`, `StockDetailItem`, section controllers) that makes it easy to add or remove sections over time.
- Automatic refresh of the quote section via a polling task while the detail screen is visible.

## Shortcuts and Future Improvements

- **Testing**: No unit or UI tests are implemented; a production app would include comprehensive coverage (view models, services, and integration tests).
- **Error handling UI**: Error states are functional but minimal; a real app would include more granular, localized error messages and retry flows.
- **Real-time updates**: Stock price updates use a simple polling mechanism; production would favor SSE or WebSockets for true real-time updates.
- **Offline caching**: No local persistence layer; future work could add caching (e.g., Core Data or SQLite) to show last-known data when offline.
- **AI insights**: The app does not currently provide AI-powered buy/hold/sell recommendations; this would be a natural next step using an LLM or on-device model.

## Open Source Libraries

This project does not use any external dependencies. Everything is implemented with the standard iOS SDK, Combine, and Swift concurrency to keep the sample focused on core Swift and iOS architecture.

## Notable Challenges and How They Were Solved

- **Debounced, cancellable search**: Implemented debounced search with `Combine` and manual `Task` cancellation so that outdated requests do not overwrite newer results.
- **Composable detail layout**: Designed a section-based architecture (section models + section controllers + cells) to keep the stock detail screen extensible and maintainable as new sections are added.
- **Coordinating multiple API calls on the detail screen**: Used `async let` to fetch quote, profile, and news in parallel, then merged them into a single `StockDetailViewState`.