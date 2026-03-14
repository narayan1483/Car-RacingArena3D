# 🏎️ Narayan's Turbo Racing

<div align="center">

![Game Banner](https://img.shields.io/badge/3D-Car%20Racing%20Game-ff4400?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZmlsbD0id2hpdGUiIGQ9Ik0xOC45MiA2LjAxQzE4LjcyIDUuNDIgMTguMTYgNSAxNy41IDVoLTExYy0uNjYgMC0xLjIxLjQyLTEuNDIgMS4wMUwzIDEydjhjMCAuNTUuNDUgMSAxIDFoMWMuNTUgMCAxLS40NSAxLTF2LTFoMTJ2MWMwIC41NS40NSAxIDEgMWgxYy41NSAwIDEtLjQ1IDEtMXYtOGwtMi4wOC01Ljk5ek02LjUgMTZjLS44MyAwLTEuNS0uNjctMS41LTEuNVMzLjY3IDEzIDQuNSAxM0g2LjV2M0g2LjV6TTkgMTZWMTBoNnY2SDl6TTE3LjUgMTZoLTJ2LTNINC41YzAuODMgMCAxLjUuNjcgMS41IDEuNVMxOC4zMyAxNiAxNy41IDE2eiIvPjwvc3ZnPg==)
![Java](https://img.shields.io/badge/Java-JSP%20%2F%20Servlet-007396?style=for-the-badge&logo=java&logoColor=white)
![Three.js](https://img.shields.io/badge/Three.js-3D%20Engine-black?style=for-the-badge&logo=three.js)
![MySQL](https://img.shields.io/badge/MySQL-Database-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Apache Tomcat](https://img.shields.io/badge/Apache-Tomcat-F8DC75?style=for-the-badge&logo=apache-tomcat&logoColor=black)

**A fully featured 3D browser-based car racing game built with Java JSP, Three.js & MySQL**

*Developed by **Narayan Prasad Maurya***

</div>

---

## 🎮 Game Preview

```
  ____  ____    ____  _   _  ____  ____  ____  ___  
 |___ \|  _ \  / ___|| | | |/ ___||  _ \/ ___||_ _| 
   __) | | | || |    | |_| |\___ \| |_) \___ \ | |  
  / __/| |_| || |___ |  _  | ___) |  __/ ___) || |  
 |_____|____/  \____||_| |_||____/|_|   |____/|___|  
         🏎️  Narayan's Turbo Racing  🏎️
```

---

## ✨ Features

- 🏎️ **Full 3D Racing** — Three.js powered 3D environment with detailed cars, road, buildings & streetlights
- 🤖 **5 Enemy Cars** — AI opponents with random lane changes and increasing speed
- 💥 **Collision System** — 2-hit system: warning on 1st hit, Game Over on 2nd
- 🎵 **Synth Music** — Web Audio API generated racing background music (no file needed)
- 🔊 **F1 Countdown Sound** — Deep beeps for 3-2-1 + horn & engine roar on GO!
- 🏆 **Leaderboard** — Top 20 players with Gold/Silver/Bronze podium
- 👤 **Login & Register** — Full user authentication system
- 💾 **Auto Score Save** — Best score saved to MySQL on Game Over
- 📱 **Touch Controls** — Mobile swipe support
- ⚙️ **Smooth Controls** — Tilt animation, smooth camera follow

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | HTML5, CSS3, JavaScript, Three.js |
| **Backend** | Java, JSP, Servlets |
| **Database** | MySQL |
| **Server** | Apache Tomcat |
| **IDE** | Apache NetBeans IDE 28 |

---

## 📁 Project Structure

```
CarRacingArena3D/
│
├── Web Pages/
│   ├── assets/
│   │   ├── audio/
│   │   │   ├── background_music.mp3
│   │   │   ├── boost.mp3
│   │   │   ├── crash.mp3
│   │   │   └── engine.mp3
│   │   ├── models/
│   │   │   ├── Road.glb
│   │   │   ├── building.glb
│   │   │   ├── car.glb
│   │   │   └── enemy_car.glb
│   │   └── textures/
│   │       ├── grass.png
│   │       ├── road.png
│   │       └── sky.png
│   │
│   ├── css/
│   │   ├── menu.css
│   │   └── style.css
│   │
│   ├── js/
│   │   ├── controls.js
│   │   ├── enemy.js
│   │   ├── game.js
│   │   ├── physics.js
│   │   ├── player.js
│   │   ├── renderer.js
│   │   ├── score.js
│   │   └── track.js
│   │
│   ├── index.html         ← Main Menu
│   ├── game.jsp           ← 3D Game (self-contained)
│   ├── login.jsp          ← Driver Login
│   ├── register.jsp       ← New Driver Register
│   └── leaderboard.jsp    ← Top Scores
│
└── Source Packages/
    ├── controller/
    │   ├── LoginServlet.java
    │   ├── RegisterServlet.java
    │   └── ScoreServlet.java
    ├── dao/
    │   ├── ScoreDAO.java
    │   └── UserDAO.java
    ├── database/
    │   ├── DBConnection.java
    │   └── racing_game.sql
    └── model/
        ├── Score.java
        └── User.java
```

---

## ⚙️ Setup & Installation

### Prerequisites
- Java JDK 21+
- Apache Tomcat / TomEE
- MySQL Server
- NetBeans IDE (recommended)
- MySQL Connector JAR (`mysql-connector-j-9.5.0.jar`)

### 1. Clone the Repository
```bash
git clone https://github.com/your-username/CarRacingArena3D.git
cd CarRacingArena3D
```

### 2. Database Setup
Open MySQL and run the SQL file:
```sql
SOURCE database/racing_game.sql;
```

Or manually create:
```sql
CREATE DATABASE racing_game;
USE racing_game;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE scores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    score INT NOT NULL
);
```

### 3. Configure Database Connection
Edit `src/database/DBConnection.java`:
```java
private static final String URL  = "jdbc:mysql://localhost:3306/racing_game";
private static final String USER = "your_mysql_username";
private static final String PASS = "your_mysql_password";
```

### 4. Add MySQL Connector
Add `mysql-connector-j-9.5.0.jar` to your project libraries.

### 5. Deploy on Tomcat
- Open project in NetBeans
- Right-click project → **Clean and Build**
- Run on Apache Tomcat (port 8082)
- Open browser: `http://localhost:8082/CarRacingArena3D/`

---

## 🎮 How to Play

| Control | Action |
|---------|--------|
| `←` `→` Arrow Keys | Steer Left / Right |
| `A` `D` Keys | Steer Left / Right |
| Touch & Swipe | Mobile steering |

### Game Rules
1. **Avoid** enemy cars — you have **2 lives**
2. 1st collision → ⚠️ Warning + score penalty
3. 2nd collision → 💥 Game Over
4. Score increases automatically as you survive
5. Speed increases as your score grows
6. **Login** to save your best score to leaderboard!

---

## 🏆 Leaderboard

- Top **20 players** shown
- **Gold 🥇 Silver 🥈 Bronze 🥉** podium for top 3
- Only your **best score** is saved (not every run)
- Score auto-saves on Game Over if you're logged in

---

## 🎵 Audio System

All sounds generated via **Web Audio API** — no external files required for game sounds:

| Sound | Trigger |
|-------|---------|
| 🔴 Beep (3-2-1) | Countdown |
| 🎺 Horn + Engine Roar | GO! |
| 💥 Crash | Collision |
| 🎵 Synth Music | Background (looped) |

---

## 📸 Screenshots

> 📌 Images are stored in `web/assets/` folder in the repository.

### 🏠 Home Screen
![Home Screen](https://raw.githubusercontent.com/narayan1483/Car-RacingArena3D/master/web/assets/home.png)

### 🎮 Gameplay
![Gameplay](https://raw.githubusercontent.com/narayan1483/Car-RacingArena3D/master/web/assets/PlayGame.png)

### 🏆 Game Score
![Game Score](https://raw.githubusercontent.com/narayan1483/Car-RacingArena3D/master/web/assets/GameScore.png)

### 🔐 Login Page
![Login](https://raw.githubusercontent.com/narayan1483/Car-RacingArena3D/master/web/assets/login.png)

### 📝 Register Page
![Register](https://raw.githubusercontent.com/narayan1483/Car-RacingArena3D/master/web/assets/register.png)

---

## 🚀 Future Plans

- [ ] Multiple race tracks
- [ ] Power-ups (Nitro boost, Shield)
- [ ] Day / Night mode toggle
- [ ] Multiplayer support
- [ ] Mobile app version
- [ ] Difficulty levels (Easy / Medium / Hard)

---

## 👨‍💻 Developer

<div align="center">

**Narayan Prasad Maurya**

*Full Stack Developer | Java | Web | Game Dev*

⚙️ Built with passion for racing games 🏎️

</div>

---

## 📄 License

This project is for educational and personal use.  
© 2026 Narayan Prasad Maurya. All rights reserved.

---

<div align="center">

🏁 **Race Hard · Beat the Record · Become the Champion** 🏁

⭐ *If you liked this project, give it a star on GitHub!* ⭐

</div>
