// score.js - Score System & HUD

var score = 0;
var gameOver = false;

// Create HUD
const hud = document.createElement("div");
hud.id = "hud";
hud.style.cssText = `
    position: fixed;
    top: 20px;
    left: 50%;
    transform: translateX(-50%);
    color: white;
    font-size: 28px;
    font-family: Arial, sans-serif;
    font-weight: bold;
    text-shadow: 2px 2px 8px black;
    z-index: 100;
    pointer-events: none;
`;
hud.innerHTML = "Score: 0";
document.body.appendChild(hud);

// Speed HUD
const speedHud = document.createElement("div");
speedHud.id = "speedHud";
speedHud.style.cssText = `
    position: fixed;
    bottom: 20px;
    right: 30px;
    color: #ff6600;
    font-size: 22px;
    font-family: Arial, sans-serif;
    font-weight: bold;
    text-shadow: 1px 1px 6px black;
    z-index: 100;
    pointer-events: none;
`;
speedHud.innerHTML = "Speed: 0 km/h";
document.body.appendChild(speedHud);

// Controls hint
const controlsHint = document.createElement("div");
controlsHint.style.cssText = `
    position: fixed;
    bottom: 20px;
    left: 30px;
    color: #aaaaaa;
    font-size: 16px;
    font-family: Arial, sans-serif;
    z-index: 100;
    pointer-events: none;
`;
controlsHint.innerHTML = "← → Arrow keys to steer";
document.body.appendChild(controlsHint);

var scoreTimer = 0;

function updateScore(delta) {
    if (gameOver) return;
    score += delta;
    if (score < 0) score = 0;
    hud.innerHTML = "Score: " + Math.floor(score);
}

function updateScoreTick() {
    if (gameOver) return;
    scoreTimer++;
    if (scoreTimer % 30 === 0) { // every 30 frames = ~1 point/sec
        score += 1;
        hud.innerHTML = "Score: " + Math.floor(score);
    }

    // Show speed
    const kmh = Math.floor(60 + score * 0.1);
    speedHud.innerHTML = "Speed: " + kmh + " km/h";
}

function showGameOver() {
    gameOver = true;
    const goDiv = document.createElement("div");
    goDiv.style.cssText = `
        position: fixed;
        top: 50%; left: 50%;
        transform: translate(-50%, -50%);
        background: rgba(0,0,0,0.85);
        color: white;
        font-size: 48px;
        font-family: Arial, sans-serif;
        font-weight: bold;
        text-align: center;
        padding: 40px 60px;
        border-radius: 20px;
        border: 3px solid #ff4400;
        z-index: 999;
    `;
    goDiv.innerHTML = `
        GAME OVER<br>
        <span style="font-size:28px">Score: ${Math.floor(score)}</span><br><br>
        <button onclick="location.reload()" style="
            padding: 14px 32px;
            font-size: 20px;
            background: linear-gradient(135deg, #ff4400, #ff8800);
            color: white;
            border: none;
            border-radius: 10px;
            cursor: pointer;
        ">Play Again</button>
        <br><br>
        <a href="index.html" style="color:#aaa; font-size:18px; text-decoration:none;">← Main Menu</a>
    `;
    document.body.appendChild(goDiv);
}
