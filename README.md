## Update: JWT Authentication, Screen Sharing, and Input Handling

### What's New
1. **JWT Authentication**: Added token-based authentication for securing the backend API and WebSocket connections. Users must log in via `/login` and provide a token to access protected routes.
   - JWT tokens are generated for authenticated users and must be included in the `Authorization` header for API requests or in the WebSocket connection query.
   
2. **Screen Sharing**: Integrated screen capture using **FFmpeg**, which streams the desktop to connected clients via WebSocket.
   - Clients can view the remote desktop in real-time after authentication.
   
3. **Mouse and Keyboard Input Handling**: Enhanced input handling to allow for mouse movements, clicks, dragging, and keyboard input from clients.
   - Clients can control the remote machine's mouse and keyboard, simulating clicks, movements, and typing.

### How to Use
1. **Login**:
   - Use the `/login` endpoint to authenticate with the system using hardcoded credentials:
     - Username: `user`
     - Password: `pass`
   - You will receive a JWT token upon successful authentication.

2. **Connect to WebSocket**:
   - Use the JWT token in the WebSocket connection query to authenticate:
     ```javascript
     const socket = io('http://localhost:5000', {
         query: { token: 'your-jwt-token' }
     });
     ```

3. **Access Protected API Endpoints**:
   - Use the token in the `Authorization` header for API requests, such as shutting down or restarting the machine:
     ```bash
     curl -H "Authorization: your-jwt-token" http://localhost:5000/shutdown
     ```
