// track.js - Buildings & Track Decorations

const buildingTextures = [0x888888, 0x556655, 0x445566];
const buildings = [];

function spawnBuilding(zPos) {
    // Left building
    const hL = 5 + Math.random() * 10;
    const gL = new THREE.BoxGeometry(4, hL, 4);
    const mL = new THREE.MeshStandardMaterial({
        color: buildingTextures[Math.floor(Math.random() * buildingTextures.length)]
    });
    const bL = new THREE.Mesh(gL, mL);
    bL.position.set(-14, hL / 2, zPos);
    bL.castShadow = true;
    scene.add(bL);
    buildings.push(bL);

    // Right building
    const hR = 5 + Math.random() * 10;
    const gR = new THREE.BoxGeometry(4, hR, 4);
    const mR = new THREE.MeshStandardMaterial({
        color: buildingTextures[Math.floor(Math.random() * buildingTextures.length)]
    });
    const bR = new THREE.Mesh(gR, mR);
    bR.position.set(14, hR / 2, zPos);
    bR.castShadow = true;
    scene.add(bR);
    buildings.push(bR);
}

// Spawn initial buildings
for (let i = 0; i < 20; i++) {
    spawnBuilding(-i * 30);
}

function updateTrack() {
    if (!playerCar) return;
    buildings.forEach(b => {
        if (b.position.z > playerCar.position.z + 50) {
            b.position.z -= 600;
        }
    });
}
