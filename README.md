# 💰 SimpleFinance

A modern iOS expense tracking application built with SwiftUI that helps users manage their personal finances, track expenses, visualize spending patterns, and set budget goals.

## 📱 Features

### Core Functionality
- **Expense Management**
  - Create, read, update, and delete expenses
  - Categorize expenses by type (Food, Transport, Entertainment, Shopping, Utilities, Other)
  - Add detailed information including amount, date, and notes
  - Attach files and images to expenses
  - Add location information to track where expenses occurred

### Visualizations & Analytics
- **Interactive Charts**
  - 📊 **Donut Chart**: Visualize expenses by category with color-coded segments
  - 📊 **Bar Chart**: View monthly expense totals with gradient styling
  - 📊 **Stacked Bar Chart**: Analyze expenses by type across different months
  - 📈 **Line Chart**: Track expense trends over time with smooth curves and area fills
  - Real-time data updates with smooth animations

### Budget Tracking
- Set total budget limits
- Track current expenses vs budget
- Define savings goals
- Visual progress indicators with color-coded status:
  - 🔴 Red: Less than 50% of goal
  - 🟡 Yellow: 50-99% of goal
  - 🟢 Green: Goal reached or exceeded

## 🏗 Architecture

### iOS App Structure
```
SimpleFinance/
├── Expenses/
│   ├── Features/
│   │   ├── Budget/           # Budget tracking and savings goals
│   │   ├── Charts/           # Data visualization components
│   │   ├── ExpenseList/      # List view with CRUD operations
│   │   └── Expenses/         # Expense forms and details
│   ├── Models/               # Data models
│   │   ├── Expense.swift
│   │   ├── ExpenseType.swift
│   │   ├── ExpenseByMonth.swift
│   │   ├── ExpenseByType.swift
│   │   └── ExpenseTypeByMonth.swift
│   └── Services/
│       ├── RemotePersistanceService.swift    # API communication
│       ├── LocalPersistenceService.swift     # Local storage
│       ├── ExpenseReportService.swift        # Data analytics
│       └── ExpenseMapper.swift               # DTO mapping
```

### Backend Server
```
server/
├── server.js              # Express.js REST API
├── package.json           # Node.js dependencies
├── Dockerfile             # Container configuration
└── docker-compose.yml     # Service orchestration
```

## 🛠 Technologies

### iOS App
- **Framework**: SwiftUI
- **Minimum iOS Version**: iOS 16.0+
- **Charts**: Swift Charts framework
- **Location Services**: CoreLocation
- **File Management**: FileManager, UniformTypeIdentifiers
- **Data Persistence**: Local and Remote options
- **Architecture Pattern**: MVVM (Model-View-ViewModel)

### Backend Server
- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: SQLite (in-memory)
- **Dependencies**:
  - `express`: ^4.18.2 - Web framework
  - `sqlite3`: ^5.1.6 - Database driver
  - `uuid`: ^9.0.0 - Unique ID generation
- **Container**: Docker support

## 📋 Prerequisites

### For iOS Development
- macOS 13.0 or later
- Xcode 15.0 or later
- iOS 16.0+ device or simulator

### For Backend Server
- Node.js 16.x or later
- npm or yarn package manager
- Docker (optional, for containerized deployment)

## 🚀 Getting Started

### 1. Clone the Repository
```bash
git clone <repository-url>
cd SimpleFinance_App
```

### 2. Setup Backend Server

#### Option A: Using Node.js Directly
```bash
cd server
npm install
npm start
```
The server will start on `http://localhost:3000`

#### Option B: Using Docker
```bash
cd server
docker-compose up -d
```

### 3. Setup iOS App

1. Open the Xcode project:
```bash
cd mobile
open SimpleFinance.xcodeproj
```

2. Configure the server URL in `RemotePersistanceService.swift` if needed (default: `http://localhost:3000`)

3. Select your target device or simulator

4. Build and run the project (⌘R)

## 📡 API Endpoints

The backend server provides the following REST API endpoints:

### Expenses
- `GET /expenses` - Get all expenses
- `GET /expenses/:id` - Get a specific expense
- `POST /expenses` - Create a new expense
- `PUT /expenses/:id` - Update an expense
- `DELETE /expenses/:id` - Delete an expense

### Request Body Example (POST/PUT)
```json
{
  "title": "Grocery Shopping",
  "type": "food",
  "amount": 45.50,
  "date": "2025-01-09T10:30:00Z",
  "locationInfo": {
    "latitude": 40.7128,
    "longitude": -74.0060,
    "name": "Supermarket XYZ"
  }
}
```

### Expense Types
- `food` - Food and dining
- `transport` - Transportation
- `entertainment` - Entertainment and leisure
- `shopping` - Shopping and retail
- `utilities` - Bills and utilities
- `other` - Miscellaneous expenses

## 🔧 Configuration

### Persistence Options
The app supports two persistence modes:

1. **Remote Persistence** (Default): Uses the backend API
   - Configure in `RemotePersistanceService.swift`
   - Update `baseURL` to match your server

2. **Local Persistence**: Uses local storage only
   - Implement in `LocalPersistenceService.swift`
   - Useful for offline mode

## 🙏 Acknowledgments

- Built with SwiftUI and Swift Charts
- Express.js for backend API
- SQLite for data storage
- Docker for containerization

## 👨‍💻 Author

**Gabriel Méndez Reyes** - Master's Student at USJ

---

<p align="center">
  Made with ❤️ for the Mobile Development Course
</p>
