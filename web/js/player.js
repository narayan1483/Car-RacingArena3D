// player.js - Player Car Loading

var playerCar = null;
var playerSpeed = 0;
var playerLane = 0; // -1 left, 0 center, 1 right
const LANE_WIDTH = 4;
const MAX_SPEED = 0.6;
const ACCELERATION = 0.01;
const FRICTION = 0.005;

const gltfLoader = new THREE.GLTFLoader();

gltfLoader.load(
    "assets/models/car.glb",
    function (gltf) {
        playerCar = gltf.scene;
        playerCar.scale.set(1.2, 1.2, 1.2);
        playerCar.position.set(0, 0.3, 5);
        playerCar.traverse(child => {
            if (child.isMesh) {
                child.castShadow = true;
                child.receiveShadow = false;
            }
        });
        scene.add(playerCar);
        console.log("Player car loaded!");
    },
    undefined,
    function (error) {
        console.warn("Car GLB load failed, using fallback box:", error);
        // Fallback: red box car
        const carGeom = new THREE.BoxGeometry(2, 1, 4);
        const carMat = new THREE.MeshStandardMaterial({ color: 0xff2200 });
        playerCar = new THREE.Mesh(carGeom, carMat);
        playerCar.position.set(0, 0.5, 5);
        playerCar.castShadow = true;
        scene.add(playerCar);
        console.log("Fallback player car added.");
    }
);

function updatePlayer() {
    if (!playerCar) return;

    // Auto forward movement
    playerCar.position.z -= MAX_SPEED;

    // Clamp X to road width
    playerCar.position.x = Math.max(-5.5, Math.min(5.5, playerCar.position.x));
}
