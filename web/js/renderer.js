// renderer.js - Scene, Camera, Renderer, Sky, Road, Grass setup

const canvas = document.getElementById("gameCanvas");
const scene = new THREE.Scene();

const camera = new THREE.PerspectiveCamera(
    75,
    window.innerWidth / window.innerHeight,
    0.1,
    1000
);

const renderer = new THREE.WebGLRenderer({ canvas: canvas, antialias: true });
renderer.setSize(window.innerWidth, window.innerHeight);
renderer.shadowMap.enabled = true;

// Camera default position
camera.position.set(0, 6, 12);

// ---- LIGHTS ----
const ambientLight = new THREE.AmbientLight(0xffffff, 0.8);
scene.add(ambientLight);

const sun = new THREE.DirectionalLight(0xffffff, 1.2);
sun.position.set(5, 10, 7);
sun.castShadow = true;
scene.add(sun);

// ---- SKY ----
const skyTexture = new THREE.TextureLoader().load("assets/textures/sky.png");
scene.background = skyTexture;

// ---- GRASS ----
const grassTexture = new THREE.TextureLoader().load("assets/textures/grass.png");
grassTexture.wrapS = THREE.RepeatWrapping;
grassTexture.wrapT = THREE.RepeatWrapping;
grassTexture.repeat.set(10, 50);
const grassGeometry = new THREE.PlaneGeometry(300, 600);
const grassMaterial = new THREE.MeshStandardMaterial({ map: grassTexture });
const grass = new THREE.Mesh(grassGeometry, grassMaterial);
grass.rotation.x = -Math.PI / 2;
grass.position.y = -0.02;
scene.add(grass);

// ---- ROAD TILES (for infinite scroll effect) ----
const roadTexture = new THREE.TextureLoader().load("assets/textures/road.png");
roadTexture.wrapS = THREE.RepeatWrapping;
roadTexture.wrapT = THREE.RepeatWrapping;
roadTexture.repeat.set(1, 20);

const roadTiles = [];
const ROAD_TILE_LENGTH = 100;
const NUM_TILES = 4;

for (let i = 0; i < NUM_TILES; i++) {
    const roadGeometry = new THREE.PlaneGeometry(14, ROAD_TILE_LENGTH);
    const roadMaterial = new THREE.MeshStandardMaterial({ map: roadTexture });
    const roadMesh = new THREE.Mesh(roadGeometry, roadMaterial);
    roadMesh.rotation.x = -Math.PI / 2;
    roadMesh.position.set(0, 0, -i * ROAD_TILE_LENGTH + ROAD_TILE_LENGTH);
    scene.add(roadMesh);
    roadTiles.push(roadMesh);
}

// ---- INFINITE ROAD SCROLL ----
function updateRoad() {
    if (!playerCar) return;
    roadTiles.forEach(tile => {
        if (tile.position.z > playerCar.position.z + ROAD_TILE_LENGTH * 1.5) {
            tile.position.z -= NUM_TILES * ROAD_TILE_LENGTH;
        }
    });
}

// ---- CAMERA FOLLOW ----
function updateCamera() {
    if (!playerCar) return;
    camera.position.x = playerCar.position.x;
    camera.position.y = playerCar.position.y + 5;
    camera.position.z = playerCar.position.z + 10;
    camera.lookAt(
        playerCar.position.x,
        playerCar.position.y + 1,
        playerCar.position.z
    );
}

// ---- RESIZE HANDLER ----
window.addEventListener("resize", () => {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight);
});
