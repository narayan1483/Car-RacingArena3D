// game.js - Main Game Loop

function animate() {
    requestAnimationFrame(animate);

    if (!gameOver) {
        updateControls();   // controls.js
        updatePlayer();     // player.js
        updateEnemies();    // enemy.js
        updateRoad();       // renderer.js
        updateTrack();      // track.js
        updatePhysics();    // physics.js
        updateCamera();     // renderer.js
        updateScoreTick();  // score.js
    }

    renderer.render(scene, camera);
}

// Start after short delay to let models begin loading
setTimeout(function () {
    animate();
    console.log("Game loop started!");
}, 500);
