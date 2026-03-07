// physics.js - Basic Physics & Boundary Checks

function updatePhysics() {
    if (!playerCar) return;

    // Keep player on road
    playerCar.position.x = Math.max(-5.5, Math.min(5.5, playerCar.position.x));

    // Keep car on ground
    playerCar.position.y = 0.3;
}
