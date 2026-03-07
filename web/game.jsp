<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>3D Car Racing Arena - Play</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { background:#000; overflow:hidden; }
        canvas { display:block; }

        /* HUD */
        #hud {
            position:fixed; top:16px; left:50%;
            transform:translateX(-50%);
            color:#fff; font-size:26px;
            font-family:Arial,sans-serif; font-weight:bold;
            text-shadow:0 0 10px #ff4400, 2px 2px 4px #000;
            z-index:100; pointer-events:none; letter-spacing:2px;
        }
        #speedometer {
            position:fixed; bottom:24px; right:32px;
            color:#ff6600; font-size:20px;
            font-family:Arial,sans-serif; font-weight:bold;
            text-shadow:1px 1px 6px #000;
            z-index:100; pointer-events:none;
        }
        #controls-hint {
            position:fixed; bottom:24px; left:32px;
            color:#aaa; font-size:15px; font-family:Arial,sans-serif;
            z-index:100; pointer-events:none;
        }

        /* COLLISION FLASH */
        #flash {
            display:none; position:fixed; inset:0;
            background:rgba(255,0,0,0.35);
            z-index:50; pointer-events:none;
        }

        /* COUNTDOWN */
        #countdown {
            display:none; position:fixed; top:50%; left:50%;
            transform:translate(-50%,-50%);
            font-family:Arial,sans-serif; font-size:110px; font-weight:900;
            color:#ffcc00; text-shadow:0 0 40px #ff8800;
            z-index:200; pointer-events:none;
            animation:cdpop 0.35s cubic-bezier(.22,1,.36,1) both;
        }
        @keyframes cdpop {
            from { transform:translate(-50%,-50%) scale(2); opacity:0; }
            to   { transform:translate(-50%,-50%) scale(1); opacity:1; }
        }

        /* AUDIO BUTTON */
        #audioBtn {
            position:fixed; top:16px; right:20px; z-index:200;
            background:rgba(0,0,0,0.55); border:1px solid rgba(255,100,0,0.4);
            color:#ff7700; font-size:20px; width:42px; height:42px;
            border-radius:50%; cursor:pointer;
            display:flex; align-items:center; justify-content:center;
            transition:all 0.2s;
        }
        #audioBtn:hover { background:rgba(255,100,0,0.2); }

        /* Developer Credit */
        #devCredit {
            position:fixed; bottom:16px; right:20px; z-index:150;
            font-family:Arial,sans-serif; font-size:11px;
            color:rgba(255,255,255,0.28); letter-spacing:1.5px;
            pointer-events:none; display:flex; align-items:center; gap:5px;
            transition:color 0.3s;
        }
        #devCredit span { color:rgba(255,110,0,0.55); font-weight:bold; letter-spacing:1px; }
        #devGear {
            color:#ff6600; opacity:0.6; font-size:12px;
            animation:devSpin 5s linear infinite; display:inline-block;
        }
        @keyframes devSpin { from{transform:rotate(0)} to{transform:rotate(360deg)} }

        /* GAME OVER SCREEN */
        #gameOver {
            display:none; position:fixed; inset:0;
            background:rgba(0,0,0,0.9); z-index:999;
            flex-direction:column; align-items:center; justify-content:center;
            font-family:Arial,sans-serif;
        }
        #gameOver.show { display:flex; animation:goIn 0.4s ease both; }
        @keyframes goIn { from{opacity:0} to{opacity:1} }

        .go-icon {
            font-size:80px; margin-bottom:10px;
            animation:crashAnim 0.5s cubic-bezier(.36,.07,.19,.97) both;
        }
        @keyframes crashAnim {
            0%,100%{transform:rotate(0)}
            25%{transform:rotate(-10deg) scale(1.2)}
            75%{transform:rotate(8deg) scale(0.95)}
        }
        .go-title {
            font-size:60px; font-weight:900; letter-spacing:6px;
            color:#fff; text-shadow:0 0 30px #ff2200, 0 0 60px #ff4400;
            margin-bottom:8px;
            animation:titlePop 0.4s 0.2s cubic-bezier(.22,1,.36,1) both;
        }
        @keyframes titlePop { from{transform:scale(0.5);opacity:0} to{transform:scale(1);opacity:1} }

        .go-label {
            font-size:14px; letter-spacing:6px; color:#ff7700;
            text-transform:uppercase; margin-bottom:4px;
        }
        .go-score {
            font-size:54px; font-weight:900; color:#ffcc00;
            text-shadow:0 0 20px #ffaa00; margin-bottom:36px;
            animation:scorePop 0.4s 0.4s cubic-bezier(.22,1,.36,1) both;
        }
        @keyframes scorePop { from{transform:scale(0.4) translateY(20px);opacity:0} to{transform:scale(1) translateY(0);opacity:1} }

        .go-btns {
            display:flex; gap:16px;
            animation:btnFade 0.4s 0.6s both;
        }
        @keyframes btnFade { from{opacity:0;transform:translateY(16px)} to{opacity:1;transform:translateY(0)} }

        .go-btn {
            padding:14px 38px; font-family:Arial,sans-serif;
            font-size:16px; font-weight:bold; letter-spacing:2px;
            text-transform:uppercase; border:none; border-radius:6px;
            cursor:pointer; transition:transform 0.15s, box-shadow 0.15s;
        }
        .go-btn-play {
            background:linear-gradient(135deg,#ff2200,#ff7700); color:#fff;
            box-shadow:0 4px 24px rgba(255,34,0,0.5);
        }
        .go-btn-play:hover { transform:translateY(-3px); box-shadow:0 8px 32px rgba(255,34,0,0.7); }
        .go-btn-menu {
            background:rgba(255,255,255,0.08); color:#bbb;
            border:1px solid rgba(255,255,255,0.18);
        }
        .go-btn-menu:hover { background:rgba(255,255,255,0.15); color:#fff; transform:translateY(-2px); }

        /* WARNING BAR - after 1st hit */
        #warningBar {
            display:none; position:fixed; top:0; left:0; right:0;
            background:linear-gradient(90deg,#ff2200,#ff7700,#ff2200);
            background-size:200% 100%;
            animation:warnSlide 0.8s linear infinite;
            height:5px; z-index:300;
        }
        @keyframes warnSlide { from{background-position:0 0} to{background-position:200% 0} }
        #warningText {
            display:none; position:fixed; top:10px; left:50%;
            transform:translateX(-50%);
            background:rgba(255,34,0,0.85); color:#fff;
            font-family:Arial,sans-serif; font-size:16px; font-weight:bold;
            letter-spacing:3px; padding:8px 24px; border-radius:4px;
            z-index:301; text-transform:uppercase;
            animation:warnBlink 0.5s ease-in-out infinite alternate;
        }
        @keyframes warnBlink { from{opacity:0.7} to{opacity:1} }
    </style>
</head>
<body>

<!-- HUD -->
<div id="hud">🏎️ Score: <span id="scoreVal">0</span></div>
<div id="speedometer">⚡ <span id="speedVal">0</span> km/h</div>
<div id="controls-hint">← → Arrow Keys &nbsp;|&nbsp; A D Keys</div>

<!-- Effects -->
<div id="flash"></div>
<div id="countdown"></div>
<div id="warningBar"></div>
<div id="warningText">⚠ WARNING — ONE MORE HIT!</div>

<!-- Audio toggle -->
<button id="audioBtn" title="Toggle Audio">🔊</button>

<!-- Game Over -->
<div id="gameOver">
    <div class="go-icon">💥</div>
    <div class="go-title">GAME OVER</div>
    <div class="go-label">Final Score</div>
    <div class="go-score" id="finalScore">0</div>
    <div id="saveStatus" style="font-size:14px;color:#aaa;margin-bottom:12px;min-height:20px;font-family:Arial,sans-serif;letter-spacing:1px;"></div>
    <div class="go-btns">
        <button class="go-btn go-btn-play" onclick="restartGame()">▶ Play Again</button>
        <button class="go-btn go-btn-menu" onclick="location.href='leaderboard.jsp'">🏆 Leaderboard</button>
        <button class="go-btn go-btn-menu" onclick="location.href='index.html'">← Menu</button>
    </div>
</div>

<!-- Developer Credit -->
<div id="devCredit">
    <span id="devGear">⚙</span>
    Developed by <span>Narayan Prasad Maurya</span>
</div>

<canvas id="gameCanvas"></canvas>

<!-- Three.js CDN -->
<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/build/three.min.js"></script>

<script>
// ================================================================
//   3D CAR RACING ARENA — Complete Game
//   Features: Game Over, Smooth Controls, Audio, Countdown
// ================================================================

// ── AUDIO SYSTEM ──────────────────────────────────────────────
let audioCtx       = null;
let engineOsc      = null;
let engineGain     = null;
let audioMuted     = false;
let bgMusicEl      = null;

function initAudio() {
    if (audioCtx) return;
    try {
        audioCtx  = new (window.AudioContext || window.webkitAudioContext)();
        engineOsc  = audioCtx.createOscillator();
        engineGain = audioCtx.createGain();
        engineOsc.type = 'sawtooth';
        engineOsc.frequency.value = 80;
        engineGain.gain.value = 0;
        engineOsc.connect(engineGain);
        engineGain.connect(audioCtx.destination);
        engineOsc.start();
    } catch(e) {}
}

function setEngineSound(speed) {
    // Engine sound disabled — synth music only
}

function muteEngine() {
    if (!audioCtx) return;
    try { engineGain.gain.setTargetAtTime(0, audioCtx.currentTime, 0.15); } catch(e) {}
}

function playCrash() {
    if (audioMuted) return;
    try {
        const a = new Audio('assets/audio/crash.mp3');
        a.volume = 0.75;
        a.play().catch(() => {
            // Web Audio fallback noise burst
            if (!audioCtx) return;
            const buf = audioCtx.createBuffer(1, Math.floor(audioCtx.sampleRate*0.3), audioCtx.sampleRate);
            const d   = buf.getChannelData(0);
            for (let i=0; i<d.length; i++) d[i] = (Math.random()*2-1)*(1-i/d.length);
            const src = audioCtx.createBufferSource();
            src.buffer = buf;
            const gn = audioCtx.createGain(); gn.gain.value = 0.4;
            src.connect(gn); gn.connect(audioCtx.destination);
            src.start();
        });
    } catch(e) {}
}

// ── BACKGROUND MUSIC (Web Audio Racing Synth) ──
let musicPlaying = false;
let musicScheduler = null;
let musicNodes = [];

const MELODY = [
    [523,0.12],[0,0.06],[659,0.12],[0,0.06],[784,0.18],[0,0.06],[698,0.12],[0,0.06],
    [659,0.12],[0,0.06],[587,0.12],[0,0.06],[523,0.25],[0,0.12],
    [392,0.12],[0,0.06],[494,0.12],[0,0.06],[587,0.18],[0,0.06],[659,0.12],[0,0.06],
    [698,0.12],[0,0.06],[784,0.12],[0,0.06],[880,0.30],[0,0.12],
    [784,0.12],[0,0.06],[698,0.12],[0,0.06],[659,0.18],[0,0.06],[587,0.12],[0,0.06],
    [523,0.12],[0,0.06],[494,0.12],[0,0.06],[392,0.25],[0,0.12],
    [440,0.09],[494,0.09],[523,0.09],[587,0.09],[659,0.09],[698,0.09],[784,0.09],[880,0.22],[0,0.12],
];
const BASS = [
    [131,0.25],[0,0.06],[165,0.25],[0,0.06],[196,0.35],[0,0.06],
    [175,0.25],[0,0.06],[165,0.25],[0,0.06],[131,0.40],[0,0.08],
    [98,0.25],[0,0.06],[123,0.25],[0,0.06],[147,0.35],[0,0.06],
    [131,0.25],[0,0.06],[110,0.25],[0,0.06],[98,0.40],[0,0.08],
];

function playNote(freq, dur, t, type, vol, ctx) {
    if (!freq || freq === 0 || !ctx) return;
    try {
        const osc = ctx.createOscillator();
        const g   = ctx.createGain();
        const f   = ctx.createBiquadFilter();
        f.type = 'lowpass'; f.frequency.value = 1800;
        osc.type = type; osc.frequency.value = freq;
        g.gain.setValueAtTime(0, t);
        g.gain.linearRampToValueAtTime(vol, t + 0.02);
        g.gain.exponentialRampToValueAtTime(vol * 0.5, t + dur * 0.6);
        g.gain.exponentialRampToValueAtTime(0.0001, t + dur * 0.92);
        osc.connect(f); f.connect(g); g.connect(ctx.destination);
        osc.start(t); osc.stop(t + dur);
        musicNodes.push(osc);
    } catch(e) {}
}

function scheduleBar(ctx, startT) {
    if (audioMuted || !ctx) return;
    // Melody
    let t = startT;
    MELODY.forEach(([fr,dur]) => { playNote(fr, dur, t, 'square', 0.07, ctx); t += dur; });
    // Bass
    let tb = startT;
    BASS.forEach(([fr,dur]) => { playNote(fr, dur, tb, 'sine', 0.10, ctx); tb += dur; });
    // Kick drum
    for (let i = 0; i < 8; i++) {
        const bt = startT + i * 0.38;
        try {
            const osc = ctx.createOscillator(), g = ctx.createGain();
            osc.type = 'sine';
            osc.frequency.setValueAtTime(150, bt);
            osc.frequency.exponentialRampToValueAtTime(35, bt + 0.1);
            g.gain.setValueAtTime(0.16, bt);
            g.gain.exponentialRampToValueAtTime(0.0001, bt + 0.14);
            osc.connect(g); g.connect(ctx.destination);
            osc.start(bt); osc.stop(bt + 0.15);
            musicNodes.push(osc);
        } catch(e) {}
    }
    // Hi-hat
    for (let i = 0; i < 16; i++) {
        const ht = startT + i * 0.19;
        try {
            const buf = ctx.createBuffer(1, Math.floor(ctx.sampleRate * 0.04), ctx.sampleRate);
            const d   = buf.getChannelData(0);
            for (let j = 0; j < d.length; j++) d[j] = (Math.random()*2-1)*(1-j/d.length);
            const src = ctx.createBufferSource(), g = ctx.createGain(), flt = ctx.createBiquadFilter();
            flt.type = 'highpass'; flt.frequency.value = 5500;
            g.gain.value = i % 2 === 0 ? 0.055 : 0.025;
            src.buffer = buf;
            src.connect(flt); flt.connect(g); g.connect(ctx.destination);
            src.start(ht); musicNodes.push(src);
        } catch(e) {}
    }
}

function barLen() { return MELODY.reduce((s,[,d])=>s+d,0); }

function startBgMusic() {
    if (audioMuted || !audioCtx || musicPlaying) return;
    musicPlaying = true;
    let nextBar = audioCtx.currentTime + 0.15;
    function loop() {
        if (!musicPlaying || audioMuted) return;
        scheduleBar(audioCtx, nextBar);
        nextBar += barLen();
        musicScheduler = setTimeout(loop, Math.max(100, (nextBar - audioCtx.currentTime - 0.6) * 1000));
    }
    loop();
}

function stopBgMusic() {
    musicPlaying = false;
    if (musicScheduler) { clearTimeout(musicScheduler); musicScheduler = null; }
    musicNodes.forEach(n => { try { n.stop(); } catch(e) {} });
    musicNodes = [];
}

// Audio button
document.getElementById('audioBtn').addEventListener('click', () => {
    audioMuted = !audioMuted;
    document.getElementById('audioBtn').textContent = audioMuted ? '🔇' : '🔊';
    if (audioMuted) { stopBgMusic(); muteEngine(); }
    else            { startBgMusic(); }
});

// ── THREE.JS SETUP ────────────────────────────────────────────
const canvas   = document.getElementById('gameCanvas');
const renderer = new THREE.WebGLRenderer({ canvas, antialias:true });
renderer.setSize(window.innerWidth, window.innerHeight);
renderer.shadowMap.enabled = true;
renderer.shadowMap.type    = THREE.PCFSoftShadowMap;
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));

const scene  = new THREE.Scene();
scene.fog    = new THREE.Fog(0x000a22, 100, 320);
scene.background = new THREE.Color(0x000a22);

const camera = new THREE.PerspectiveCamera(70, window.innerWidth/window.innerHeight, 0.1, 500);
camera.position.set(0, 5.5, 12);

window.addEventListener('resize', () => {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight);
});

// ── LIGHTS ────────────────────────────────────────────────────
scene.add(new THREE.AmbientLight(0x334466, 0.9));

const sun = new THREE.DirectionalLight(0xffeedd, 1.5);
sun.position.set(15, 25, 10);
sun.castShadow = true;
sun.shadow.mapSize.set(1024, 1024);
scene.add(sun);

const carLight = new THREE.PointLight(0xffdd88, 2.0, 35);
scene.add(carLight);

// ── STARS ─────────────────────────────────────────────────────
(function(){
    const geo = new THREE.BufferGeometry();
    const v   = [];
    for (let i=0; i<2000; i++)
        v.push((Math.random()-.5)*500, 20+Math.random()*80, (Math.random()-.5)*500);
    geo.setAttribute('position', new THREE.Float32BufferAttribute(v, 3));
    scene.add(new THREE.Points(geo, new THREE.PointsMaterial({ color:0xffffff, size:0.35 })));
})();

// ── ROAD ──────────────────────────────────────────────────────
const ROAD_W   = 14;
const TILE_LEN = 80;
const N_TILES  = 6;
const roadTiles = [];

const roadMat  = new THREE.MeshStandardMaterial({ color:0x1a1a1a, roughness:0.9 });
const dashMat  = new THREE.MeshStandardMaterial({ color:0xffee00 });
const edgeMat  = new THREE.MeshStandardMaterial({ color:0xffffff });
const kerbR    = new THREE.MeshStandardMaterial({ color:0xdd2222 });
const kerbW    = new THREE.MeshStandardMaterial({ color:0xeeeeee });

function makeRoadTile(z) {
    const g = new THREE.Group();
    // Surface
    const surf = new THREE.Mesh(new THREE.PlaneGeometry(ROAD_W, TILE_LEN), roadMat);
    surf.rotation.x = -Math.PI/2; surf.receiveShadow = true; g.add(surf);
    // Center dashes
    for (let dz=-TILE_LEN/2+6; dz<TILE_LEN/2; dz+=12) {
        const d = new THREE.Mesh(new THREE.PlaneGeometry(0.28,5.5), dashMat);
        d.rotation.x = -Math.PI/2; d.position.set(0,0.01,dz); g.add(d);
    }
    // Lane lines
    [-3.5,3.5].forEach(x => {
        const ln = new THREE.Mesh(new THREE.PlaneGeometry(0.15,TILE_LEN), edgeMat);
        ln.rotation.x = -Math.PI/2; ln.position.set(x,0.01,0); g.add(ln);
    });
    // Edge lines
    [-6.8,6.8].forEach(x => {
        const el = new THREE.Mesh(new THREE.PlaneGeometry(0.35,TILE_LEN), edgeMat);
        el.rotation.x = -Math.PI/2; el.position.set(x,0.01,0); g.add(el);
    });
    // Kerbs
    for (let dz=-TILE_LEN/2; dz<TILE_LEN/2; dz+=3) {
        const mat = (Math.floor(dz/3)%2===0) ? kerbR : kerbW;
        [-7.4,7.4].forEach(x => {
            const k = new THREE.Mesh(new THREE.BoxGeometry(0.8,0.15,3), mat);
            k.position.set(x,0.07,dz+1.5); g.add(k);
        });
    }
    g.position.set(0,0,z); scene.add(g); roadTiles.push(g);
}

for (let i=0; i<N_TILES; i++) makeRoadTile(-i*TILE_LEN + TILE_LEN*1.5);

// Grass
const grassMat = new THREE.MeshStandardMaterial({ color:0x1d5c1d });
[-110,110].forEach(x => {
    const gp = new THREE.Mesh(new THREE.PlaneGeometry(200,2000), grassMat);
    gp.rotation.x = -Math.PI/2;
    gp.position.set(x,-0.06,-600);
    gp.receiveShadow = true; scene.add(gp);
});

// ── CAR BUILDER ───────────────────────────────────────────────
function buildCar(bodyColor, accentColor) {
    const g       = new THREE.Group();
    const bodyMat = new THREE.MeshStandardMaterial({ color:bodyColor, metalness:0.7, roughness:0.25 });
    const accMat  = new THREE.MeshStandardMaterial({ color:accentColor, metalness:0.5 });
    const glasMat = new THREE.MeshStandardMaterial({ color:0x112233, transparent:true, opacity:0.7, roughness:0.05 });
    const whlMat  = new THREE.MeshStandardMaterial({ color:0x111111, roughness:0.95 });
    const rimMat  = new THREE.MeshStandardMaterial({ color:0xcccccc, metalness:0.9, roughness:0.2 });
    const hlMat   = new THREE.MeshStandardMaterial({ color:0xffffcc, emissive:0xffffcc, emissiveIntensity:2.5 });
    const tlMat   = new THREE.MeshStandardMaterial({ color:0xff1100, emissive:0xff1100, emissiveIntensity:1.8 });

    // Body
    const body = new THREE.Mesh(new THREE.BoxGeometry(2.3,0.65,4.6), bodyMat);
    body.position.y=0.55; body.castShadow=true; g.add(body);
    // Hood
    const hood = new THREE.Mesh(new THREE.BoxGeometry(2.1,0.18,1.2), bodyMat);
    hood.position.set(0,0.97,-1.45); hood.rotation.x=0.2; hood.castShadow=true; g.add(hood);
    // Cabin
    const cabin = new THREE.Mesh(new THREE.BoxGeometry(1.7,0.58,2.1), glasMat);
    cabin.position.set(0,1.13,-0.1); cabin.castShadow=true; g.add(cabin);
    // Roof
    const roof = new THREE.Mesh(new THREE.BoxGeometry(1.65,0.12,2.05), bodyMat);
    roof.position.set(0,1.44,-0.1); g.add(roof);
    // Spoiler
    const sp = new THREE.Mesh(new THREE.BoxGeometry(2.1,0.12,0.45), accMat);
    sp.position.set(0,1.12,2.1); g.add(sp);
    const spL = new THREE.Mesh(new THREE.BoxGeometry(0.12,0.5,0.45), accMat);
    spL.position.set(-0.95,0.9,2.1); g.add(spL);
    const spR = spL.clone(); spR.position.x=0.95; g.add(spR);
    // Bumpers
    const fb = new THREE.Mesh(new THREE.BoxGeometry(2.3,0.32,0.22), accMat);
    fb.position.set(0,0.28,-2.42); g.add(fb);
    const rb = fb.clone(); rb.position.z=2.42; g.add(rb);
    // Headlights & taillights
    [[-0.65],[0.65]].forEach(([x]) => {
        const hl = new THREE.Mesh(new THREE.BoxGeometry(0.5,0.22,0.1), hlMat);
        hl.position.set(x,0.58,-2.33); g.add(hl);
        const tl = new THREE.Mesh(new THREE.BoxGeometry(0.5,0.22,0.1), tlMat);
        tl.position.set(x,0.58,2.33); g.add(tl);
    });
    // Side skirts
    [-1.17,1.17].forEach(x => {
        const sk = new THREE.Mesh(new THREE.BoxGeometry(0.12,0.18,3.8), accMat);
        sk.position.set(x,0.27,0); g.add(sk);
    });
    // Wheels
    const wGeo = new THREE.CylinderGeometry(0.44,0.44,0.36,18);
    const rGeo = new THREE.CylinderGeometry(0.26,0.26,0.37,8);
    [[1.2,0.38,-1.45],[-1.2,0.38,-1.45],[1.2,0.38,1.45],[-1.2,0.38,1.45]].forEach(([x,y,z]) => {
        const wg = new THREE.Group();
        const w  = new THREE.Mesh(wGeo, whlMat); w.rotation.z=Math.PI/2; wg.add(w);
        const r  = new THREE.Mesh(rGeo, rimMat);  r.rotation.z=Math.PI/2; wg.add(r);
        wg.position.set(x,y,z); wg.castShadow=true; g.add(wg);
    });
    return g;
}

// ── PLAYER CAR ────────────────────────────────────────────────
const playerCar = buildCar(0xff2200, 0xff7700);
playerCar.position.set(0, 0, 5);
scene.add(playerCar);

// ── ENEMY CARS ────────────────────────────────────────────────
const LANES    = [-4, 0, 4, -2, 2];
const ePairs   = [[0x0044ff,0x00aaff],[0x00cc44,0xaaff00],[0xcc00cc,0xff44ff],[0xff9900,0xffcc00],[0x00aacc,0x00ffee]];
const enemies  = [];

for (let i=0; i<5; i++) {
    const ec = buildCar(ePairs[i][0], ePairs[i][1]);
    ec.position.set(LANES[i%LANES.length], 0, -70 - i*30);
    ec.rotation.y = Math.PI;
    scene.add(ec);
    enemies.push({ mesh:ec, speed:0.18+Math.random()*0.12 });
}

// ── BUILDINGS & LIGHTS ────────────────────────────────────────
const scenery  = [];
const bColors  = [0x223344,0x334422,0x442233,0x332244,0x443322,0x224433];
const winMat   = new THREE.MeshStandardMaterial({ color:0xffee88, emissive:0xffee88, emissiveIntensity:0.7 });
const poleMat  = new THREE.MeshStandardMaterial({ color:0x778899 });

function spawnScenery(z) {
    [-1,1].forEach(side => {
        const h=8+Math.random()*20, w=5+Math.random()*6, d=5+Math.random()*6;
        const mat = new THREE.MeshStandardMaterial({ color:bColors[Math.floor(Math.random()*bColors.length)], roughness:0.7 });
        const b   = new THREE.Mesh(new THREE.BoxGeometry(w,h,d), mat);
        b.position.set(side>0?14+w/2:-14-w/2, h/2, z+(Math.random()-.5)*8);
        b.castShadow=true; scene.add(b); scenery.push(b);
        // Windows
        for (let wr=1; wr<h-1; wr+=3.5) {
            for (let wc=-1; wc<=1; wc++) {
                if (Math.random()>0.35) {
                    const win = new THREE.Mesh(new THREE.PlaneGeometry(0.7,0.7), winMat);
                    win.position.set(side>0?14+w/2:-14-w/2, wr, z+wc*1.4);
                    win.rotation.y = side>0?-Math.PI/2:Math.PI/2;
                    scene.add(win); scenery.push(win);
                }
            }
        }
    });
    // Street lights
    [-9.5,9.5].forEach(x => {
        const pole = new THREE.Mesh(new THREE.CylinderGeometry(0.1,0.1,5.5,8), poleMat);
        pole.position.set(x,2.75,z); scene.add(pole); scenery.push(pole);
        const arm = new THREE.Mesh(new THREE.BoxGeometry(0.08,0.08,2), poleMat);
        arm.position.set(x>0?x-1:x+1, 5.5, z); scene.add(arm); scenery.push(arm);
        const bulb = new THREE.Mesh(new THREE.SphereGeometry(0.22,8,8),
            new THREE.MeshStandardMaterial({ color:0xfffaaa, emissive:0xfffaaa, emissiveIntensity:3 }));
        bulb.position.set(x>0?x-2:x+2, 5.4, z); scene.add(bulb); scenery.push(bulb);
    });
}
for (let i=0; i<35; i++) spawnScenery(-i*22);

// ── INPUT ─────────────────────────────────────────────────────
const keys = {};
document.addEventListener('keydown', e => {
    keys[e.key] = true;
    if(['ArrowLeft','ArrowRight','ArrowUp','ArrowDown',' '].includes(e.key)) e.preventDefault();
    if (!audioCtx) { initAudio(); startBgMusic(); }
});
document.addEventListener('keyup', e => { keys[e.key] = false; });

let touchX = 0;
document.addEventListener('touchstart', e => {
    touchX = e.touches[0].clientX;
    if (!audioCtx) { initAudio(); startBgMusic(); }
});
document.addEventListener('touchmove', e => {
    if (!gameRunning) return;
    const dx = e.touches[0].clientX - touchX;
    playerCar.position.x = Math.max(-5.5, Math.min(5.5, playerCar.position.x + dx*0.035));
    touchX = e.touches[0].clientX;
    e.preventDefault();
}, { passive:false });

// ── GAME STATE ────────────────────────────────────────────────
let score        = 0;
let gameRunning  = false;
let frameCount   = 0;
let gameSpeed    = 0.48;
const BASE_SPEED = 0.48;

// Crash system: 2 hits = game over
let hitCount     = 0;
let collCooldown = false;
let crashed      = false;

// Smooth camera vars
let camX = 0, camY = 5.5, camZ = 12;

// DOM refs
const scoreValEl   = document.getElementById('scoreVal');
const speedValEl   = document.getElementById('speedVal');
const gameOverEl   = document.getElementById('gameOver');
const finalScoreEl = document.getElementById('finalScore');
const flashEl      = document.getElementById('flash');
const countdownEl  = document.getElementById('countdown');
const warningBarEl = document.getElementById('warningBar');
const warningTxtEl = document.getElementById('warningText');

// ── COUNTDOWN ────────────────────────────────────────────────
// ── COUNTDOWN SOUNDS ─────────────────────────────────────────
function playBeep(freq, dur, vol, type) {
    try {
        if (!audioCtx) initAudio();
        if (!audioCtx) return;
        const osc  = audioCtx.createOscillator();
        const gain = audioCtx.createGain();
        osc.type = type || 'sine';
        osc.frequency.value = freq;
        gain.gain.setValueAtTime(0, audioCtx.currentTime);
        gain.gain.linearRampToValueAtTime(vol, audioCtx.currentTime + 0.01);
        gain.gain.exponentialRampToValueAtTime(0.0001, audioCtx.currentTime + dur);
        osc.connect(gain); gain.connect(audioCtx.destination);
        osc.start(); osc.stop(audioCtx.currentTime + dur + 0.05);
    } catch(e) {}
}

function playCountBeep(num) {
    if (num === 3) {
        // Low tone for 3
        playBeep(440, 0.25, 0.4, 'sine');
    } else if (num === 2) {
        // Mid tone for 2
        playBeep(554, 0.25, 0.4, 'sine');
    } else if (num === 1) {
        // High tone for 1
        playBeep(659, 0.25, 0.4, 'sine');
    }
}

function playGoSound() {
    try {
        if (!audioCtx) initAudio();
        if (!audioCtx) return;
        // Exciting GO! — two rising tones + engine rev burst
        const now = audioCtx.currentTime;

        // Chord: two tones together
        [784, 988, 1175].forEach((freq, i) => {
            const osc  = audioCtx.createOscillator();
            const gain = audioCtx.createGain();
            osc.type = 'triangle';
            osc.frequency.value = freq;
            gain.gain.setValueAtTime(0, now + i*0.04);
            gain.gain.linearRampToValueAtTime(0.25, now + i*0.04 + 0.02);
            gain.gain.exponentialRampToValueAtTime(0.0001, now + i*0.04 + 0.45);
            osc.connect(gain); gain.connect(audioCtx.destination);
            osc.start(now + i*0.04);
            osc.stop(now + i*0.04 + 0.5);
        });

        // Engine rev burst
        const revOsc  = audioCtx.createOscillator();
        const revGain = audioCtx.createGain();
        revOsc.type = 'sawtooth';
        revOsc.frequency.setValueAtTime(120, now + 0.1);
        revOsc.frequency.exponentialRampToValueAtTime(380, now + 0.55);
        revGain.gain.setValueAtTime(0, now + 0.1);
        revGain.gain.linearRampToValueAtTime(0.18, now + 0.15);
        revGain.gain.exponentialRampToValueAtTime(0.0001, now + 0.6);
        revOsc.connect(revGain); revGain.connect(audioCtx.destination);
        revOsc.start(now + 0.1); revOsc.stop(now + 0.65);

    } catch(e) {}
}

function startCountdown() {
    gameRunning = false;
    let count   = 3;
    countdownEl.style.display = 'block';
    countdownEl.style.color   = '#ffcc00';
    countdownEl.textContent   = count;

    // Play first beep immediately for 3
    setTimeout(() => playCountBeep(3), 50);

    const t = setInterval(() => {
        count--;
        if (count > 0) {
            // Re-trigger animation
            countdownEl.style.animation = 'none';
            void countdownEl.offsetWidth;
            countdownEl.style.animation = 'cdpop 0.35s cubic-bezier(.22,1,.36,1) both';
            countdownEl.textContent = count;
            playCountBeep(count);
        } else if (count === 0) {
            countdownEl.style.animation = 'none';
            void countdownEl.offsetWidth;
            countdownEl.style.animation = 'cdpop 0.35s cubic-bezier(.22,1,.36,1) both';
            countdownEl.textContent = 'GO!';
            countdownEl.style.color = '#00ff88';
            playGoSound();
        } else {
            clearInterval(t);
            countdownEl.style.display = 'none';
            countdownEl.style.color   = '#ffcc00';
            gameRunning = true;
            initAudio();
            startBgMusic();
        }
    }, 800);
}

// ── COLLISION ────────────────────────────────────────────────
function onHit() {
    if (collCooldown || !gameRunning) return;
    collCooldown = true;
    hitCount++;
    playCrash();

    // Flash screen
    flashEl.style.display    = 'block';
    flashEl.style.background = 'rgba(255,0,0,0.5)';

    // Camera shake
    let shakes = 0;
    const shk = setInterval(() => {
        camera.position.x += (Math.random()-.5)*0.5;
        camera.position.y += (Math.random()-.5)*0.3;
        if (++shakes >= 8) clearInterval(shk);
    }, 40);

    setTimeout(() => { flashEl.style.background = 'rgba(255,0,0,0.2)'; }, 200);
    setTimeout(() => {
        flashEl.style.display = 'none';
        collCooldown = false;
    }, 600);

    if (hitCount === 1) {
        // First hit — show warning, deduct score
        score = Math.max(0, score - 15);
        scoreValEl.textContent = Math.floor(score);
        warningBarEl.style.display = 'block';
        warningTxtEl.style.display = 'block';
        setTimeout(() => {
            warningBarEl.style.display = 'none';
            warningTxtEl.style.display = 'none';
        }, 2500);
    } else {
        // Second hit — GAME OVER
        triggerGameOver();
    }
}

function triggerGameOver() {
    if (!gameRunning) return;
    gameRunning = false;
    muteEngine();
    stopBgMusic();
    playCrash();

    // Flip car animation
    let angle = 0;
    const flip = setInterval(() => {
        angle += 0.14;
        playerCar.rotation.z  = Math.sin(angle)*0.7;
        playerCar.rotation.x += 0.08;
        playerCar.position.y  = Math.max(0, playerCar.position.y - 0.07);
        if (angle > Math.PI) {
            clearInterval(flip);
            showGameOver();
        }
    }, 28);
}

function saveScoreToDB(finalScore) {
    // Only save if user is logged in (session check via hidden field)
    fetch('saveScore', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'score=' + finalScore
    })
    .then(res => res.text())
    .then(msg => {
        console.log('Score save:', msg);
        if (msg.trim() === 'Score Saved') {
            document.getElementById('saveStatus').textContent = '✅ Score Saved!';
            document.getElementById('saveStatus').style.color = '#00ff88';
        } else if (msg.trim() === 'Login Required') {
            document.getElementById('saveStatus').innerHTML = '⚠ <a href="login.jsp" style="color:#ffcc00">Login to save score</a>';
        } else {
            document.getElementById('saveStatus').textContent = '';
        }
    })
    .catch(() => {
        document.getElementById('saveStatus').textContent = '';
    });
}

function showGameOver() {
    const finalScore = Math.floor(score);
    finalScoreEl.textContent = finalScore;
    gameOverEl.classList.add('show');
    document.getElementById('saveStatus').textContent = '💾 Saving score...';
    saveScoreToDB(finalScore);
}

// ── RESTART ──────────────────────────────────────────────────
function restartGame() {
    gameOverEl.classList.remove('show');
    score      = 0;
    gameSpeed  = BASE_SPEED;
    frameCount = 0;
    hitCount   = 0;
    crashed    = false;
    collCooldown = false;
    scoreValEl.textContent = '0';
    speedValEl.textContent = '0';

    playerCar.position.set(0, 0, 5);
    playerCar.rotation.set(0, 0, 0);

    enemies.forEach((e,i) => {
        e.mesh.position.set(LANES[i%LANES.length], 0, -70-i*30);
        e.mesh.rotation.set(0, Math.PI, 0);
        e.speed = 0.18 + Math.random()*0.12;
    });

    camX = 0; camY = 5.5; camZ = playerCar.position.z + 12;
    startCountdown();
}

// ── MAIN LOOP ────────────────────────────────────────────────
const clock = new THREE.Clock();

function animate() {
    requestAnimationFrame(animate);
    const dt = Math.min(clock.getDelta(), 0.05);

    renderer.render(scene, camera);
    if (!gameRunning) return;

    frameCount++;
    gameSpeed = BASE_SPEED + Math.floor(score/40)*0.025;

    // ── PLAYER MOVEMENT (smooth & controlled) ──
    const steer = 6.0 * dt;
    if (keys['ArrowLeft'] || keys['a'] || keys['A']) {
        playerCar.position.x -= steer;
        playerCar.rotation.z  = Math.min(playerCar.rotation.z + 2.5*dt, 0.14);
    } else if (keys['ArrowRight'] || keys['d'] || keys['D']) {
        playerCar.position.x += steer;
        playerCar.rotation.z  = Math.max(playerCar.rotation.z - 2.5*dt, -0.14);
    } else {
        playerCar.rotation.z += (0 - playerCar.rotation.z) * 5 * dt;
    }
    playerCar.position.x = Math.max(-5.5, Math.min(5.5, playerCar.position.x));
    playerCar.position.y = 0;
    playerCar.position.z -= gameSpeed;
    playerCar.children.forEach(c => { if (c.isGroup) c.rotation.x -= gameSpeed*0.7; });

    // ── ENGINE SOUND ──
    setEngineSound(gameSpeed / 1.2);

    // ── ROAD RECYCLE ──
    roadTiles.forEach(t => {
        if (t.position.z > playerCar.position.z + TILE_LEN*2.5)
            t.position.z -= N_TILES * TILE_LEN;
    });

    // ── SCENERY RECYCLE ──
    scenery.forEach(b => {
        if (b.position.z > playerCar.position.z + 90)
            b.position.z -= 770;
    });

    // ── ENEMIES ──
    enemies.forEach((e,i) => {
        e.mesh.position.z += e.speed;
        if (e.mesh.position.z > playerCar.position.z + 35) {
            e.mesh.position.z = playerCar.position.z - 100 - Math.random()*80;
            e.mesh.position.x = LANES[Math.floor(Math.random()*LANES.length)];
            e.speed = 0.18 + Math.random()*0.14 + Math.floor(score/80)*0.02;
        }
        e.mesh.children.forEach(c => { if (c.isGroup) c.rotation.x += e.speed*0.7; });

        // ── COLLISION CHECK ──
        const dx = Math.abs(e.mesh.position.x - playerCar.position.x);
        const dz = Math.abs(e.mesh.position.z - playerCar.position.z);
        if (dx < 1.8 && dz < 3.0) onHit();
    });

    // ── HEADLIGHT ──
    carLight.position.set(playerCar.position.x, playerCar.position.y+3, playerCar.position.z-6);

    // ── SMOOTH CAMERA FOLLOW ──
    const tX = playerCar.position.x * 0.6;
    const tY = playerCar.position.y + 5.5;
    const tZ = playerCar.position.z + 11.5;
    camX += (tX - camX) * 0.08;
    camY += (tY - camY) * 0.15;
    camZ += (tZ - camZ) * 0.15;
    camera.position.set(camX, camY, camZ);
    camera.lookAt(playerCar.position.x*0.3, playerCar.position.y+0.8, playerCar.position.z-6);

    // ── HUD ──
    if (frameCount % 18 === 0) {
        score += 1;
        scoreValEl.textContent = Math.floor(score);
    }
    if (frameCount % 8 === 0) {
        speedValEl.textContent = Math.floor(80 + gameSpeed*80 + score*0.3);
    }
}

// ── START ─────────────────────────────────────────────────────
startCountdown();
animate();
</script>
</body>
</html>
