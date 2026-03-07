// enemy.js - Enemy Cars

var enemyCars = [];
const NUM_ENEMIES = 3;
const ENEMY_SPEED = 0.35;
var enemiesLoaded = 0;

const enemyStartPositions = [
    { x: -4, z: -40 },
    { x: 0,  z: -80 },
    { x: 4,  z: -120 }
];

function spawnEnemy(index) {
    gltfLoader.load(
        "assets/models/enemy_car.glb",
        function (gltf) {
            const enemy = gltf.scene;
            enemy.scale.set(1, 1, 1);
            const pos = enemyStartPositions[index];
            enemy.position.set(pos.x, 0.3, pos.z);
            enemy.rotation.y = Math.PI; // face opposite direction
            enemy.traverse(child => {
                if (child.isMesh) {
                    child.castShadow = true;
                }
            });
            scene.add(enemy);
            enemyCars.push(enemy);
            console.log("Enemy car " + index + " loaded!");
        },
        undefined,
        function (error) {
            console.warn("Enemy GLB load failed, using fallback:", error);
            // Fallback: blue box enemy
            const eGeom = new THREE.BoxGeometry(2, 1, 4);
            const eMat = new THREE.MeshStandardMaterial({ color: 0x0044ff });
            const enemy = new THREE.Mesh(eGeom, eMat);
            const pos = enemyStartPositions[index];
            enemy.position.set(pos.x, 0.5, pos.z);
            enemy.castShadow = true;
            scene.add(enemy);
            enemyCars.push(enemy);
            console.log("Fallback enemy " + index + " added.");
        }
    );
}

// Spawn all enemies
for (let i = 0; i < NUM_ENEMIES; i++) {
    spawnEnemy(i);
}

function updateEnemies() {
    if (!playerCar) return;

    enemyCars.forEach(function (enemy, i) {
        // Move enemy forward (toward player)
        enemy.position.z += ENEMY_SPEED;

        // If enemy passes player, reset it far ahead
        if (enemy.position.z > playerCar.position.z + 30) {
            enemy.position.z = playerCar.position.z - 150 - (i * 40);
            // Randomize lane
            const lanes = [-4, 0, 4];
            enemy.position.x = lanes[Math.floor(Math.random() * lanes.length)];
        }

        // Simple collision check with player
        if (playerCar) {
            const dx = Math.abs(enemy.position.x - playerCar.position.x);
            const dz = Math.abs(enemy.position.z - playerCar.position.z);
            if (dx < 2.5 && dz < 4) {
                handleCollision();
            }
        }
    });
}

function handleCollision() {
    // Flash screen red briefly
    if (!window._collisionCooldown) {
        window._collisionCooldown = true;
        document.body.style.boxShadow = "inset 0 0 80px red";
        updateScore(-5); // penalty
        setTimeout(() => {
            document.body.style.boxShadow = "none";
            window._collisionCooldown = false;
        }, 400);
    }
}
