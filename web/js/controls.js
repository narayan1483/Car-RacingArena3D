// controls.js - Keyboard & Touch Controls

const keys = {};

document.addEventListener("keydown", function (e) {
    keys[e.key] = true;
});
document.addEventListener("keyup", function (e) {
    keys[e.key] = false;
});

function updateControls() {
    if (!playerCar) return;

    if (keys["ArrowLeft"] || keys["a"] || keys["A"]) {
        playerCar.position.x -= 0.15;
        playerCar.rotation.z = Math.min(playerCar.rotation.z + 0.05, 0.2);
    } else if (keys["ArrowRight"] || keys["d"] || keys["D"]) {
        playerCar.position.x += 0.15;
        playerCar.rotation.z = Math.max(playerCar.rotation.z - 0.05, -0.2);
    } else {
        // Return to upright
        playerCar.rotation.z *= 0.8;
    }
}

// ---- TOUCH CONTROLS (mobile) ----
let touchStartX = 0;

document.addEventListener("touchstart", function (e) {
    touchStartX = e.touches[0].clientX;
});

document.addEventListener("touchmove", function (e) {
    if (!playerCar) return;
    const dx = e.touches[0].clientX - touchStartX;
    playerCar.position.x += dx * 0.02;
    touchStartX = e.touches[0].clientX;
    playerCar.position.x = Math.max(-5.5, Math.min(5.5, playerCar.position.x));
});
