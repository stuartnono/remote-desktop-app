# remote-desktop-app
Here’s an updated version of your `README` that provides detailed setup instructions for those who will contribute or collaborate on the backend:

---

**Remote Desktop app** that allows users to access and control a computer from a remote location via a network connection.

---

### Table of Contents
- [Project Overview](#project-overview)
- [Backend Setup](#backend-setup)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Running the Backend Server](#running-the-backend-server)
  - [APIs and WebSocket Communication](#apis-and-websocket-communication)
  - [Contributing](#contributing)
  - [Common Issues and Troubleshooting](#common-issues-and-troubleshooting)
  
---

### Project Overview
This project enables users to:
- Share their screen with a remote client.
- Control the remote machine using mouse and keyboard inputs.
- Remotely shut down or restart the computer.

The backend is built with **Node.js** and utilizes **Socket.io** for real-time communication.

---

### Backend Setup

#### Prerequisites
Before setting up the backend, ensure the following dependencies are installed:
1. **Node.js** (Latest version)
   - Download from [Node.js official website](https://nodejs.org/).
   - Verify installation:
     ```bash
     node -v
     npm -v
     ```
2. **Visual Studio with Desktop Development with C++**
   - Required to compile native modules (for example, `robotjs`).
   - Download from [Visual Studio](https://visualstudio.microsoft.com/) and install the **Desktop Development with C++** workload.
3. **Git** (For version control)
   - Download from [Git](https://git-scm.com/).

#### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/stuartnono/remote-desktop-app.git
   cd remote-desktop-app/remote-desktop-app-backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

   - This will install required packages including:
     - **express**: For the HTTP server.
     - **socket.io**: For real-time WebSocket communication.
     - **robotjs**: To simulate mouse and keyboard actions.
     - **child_process**: For executing system commands (shutdown, restart).

#### Running the Backend Server
To run the backend server:
1. Start the server:
   ```bash
   node index.js
   ```

2. The server will start running at `http://localhost:5000/`. You should see:
   ```bash
   Server is running on port 5000
   ```

3. To test the endpoints:
   - Visit `http://localhost:5000/` in your browser.
   - To shut down the machine, visit: `http://localhost:5000/shutdown`.
   - To restart the machine, visit: `http://localhost:5000/restart`.

#### APIs and WebSocket Communication
The backend uses **WebSockets** for real-time communication between the client and the server for:
- **Mouse Movements**: Moves the remote machine’s mouse based on the client’s input.
- **Keyboard Input**: Simulates key presses from the client on the remote machine.
  
Endpoints:
- `GET /shutdown`: Shuts down the remote machine.
- `GET /restart`: Restarts the remote machine.

WebSocket Events:
- `mouseMove`: Handles mouse movement.
- `mouseClick`: Handles mouse clicks.
- `keyPress`: Handles keyboard inputs.

---

### Contributing
If you’d like to contribute to the backend development, follow these steps:

1. **Fork the repository**:
   - Create your own fork of the repository on GitHub.

2. **Create a new branch**:
   ```bash
   git checkout -b feature-branch-name
   ```

3. **Make your changes**.

4. **Commit and push your changes**:
   ```bash
   git add .
   git commit -m "Description of changes"
   git push origin feature-branch-name
   ```

5. **Create a pull request** on GitHub and submit it for review.

---

### Common Issues and Troubleshooting

#### 1. `node-gyp` Errors on Windows
If you encounter `node-gyp` errors, it’s likely due to missing build tools required to compile native modules. Make sure you’ve installed **Visual Studio** with **Desktop Development with C++**.

To resolve the issue:
- Run:
  ```bash
  npm install --global --production windows-build-tools
  ```

#### 2. Server Port in Use
If you see an error that the port `5000` is in use, you can specify a different port:
```bash
PORT=6000 node index.js
```

#### 3. Authentication Issues with Git
If you have issues pushing to GitHub, ensure you're using a personal access token (PAT) instead of your password. You can generate a PAT [here](https://github.com/settings/tokens).

