<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — 3D Car Racing Arena</title>
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&family=Rajdhani:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --red:     #ff2200;
            --orange:  #ff7700;
            --yellow:  #ffcc00;
            --dark:    #080a10;
            --card:    #0d1018;
            --border:  #ff220033;
            --text:    #e8eaf0;
            --muted:   #667088;
        }

        *, *::before, *::after { margin:0; padding:0; box-sizing:border-box; }

        body {
            font-family: 'Rajdhani', sans-serif;
            background: var(--dark);
            color: var(--text);
            min-height: 100vh;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* ── ANIMATED ROAD BACKGROUND ── */
        .bg {
            position: fixed; inset: 0; z-index: 0;
            background: linear-gradient(180deg, #000510 0%, #050a18 40%, #0a0808 100%);
        }

        /* Stars */
        .stars {
            position: fixed; inset: 0; z-index: 1; overflow: hidden;
        }
        .star {
            position: absolute;
            background: #fff;
            border-radius: 50%;
            animation: twinkle var(--d, 3s) ease-in-out infinite alternate;
        }

        @keyframes twinkle { from { opacity: 0.1; } to { opacity: 0.9; } }

        /* Road lines rushing toward camera */
        .road-wrap {
            position: fixed; inset: 0; z-index: 2;
            perspective: 300px;
            pointer-events: none;
        }
        .road {
            position: absolute;
            bottom: 0; left: 50%;
            transform: translateX(-50%);
            width: 300px; height: 100%;
            background: linear-gradient(180deg, #111 0%, #1a1a1a 100%);
            clip-path: polygon(30% 0%, 70% 0%, 100% 100%, 0% 100%);
            opacity: 0.45;
        }
        .road-line {
            position: absolute;
            left: 50%; transform: translateX(-50%);
            width: 6px;
            background: linear-gradient(180deg, var(--yellow) 0%, transparent 100%);
            animation: rush var(--dur, 1s) linear infinite;
            opacity: 0.7;
        }
        @keyframes rush {
            from { bottom: 100%; height: 0; }
            to   { bottom: -5%;  height: 55%; }
        }

        /* Speed lines */
        .speed-line {
            position: fixed;
            top: 0; height: 100%;
            width: 1px;
            background: linear-gradient(180deg, transparent, var(--orange) 50%, transparent);
            opacity: 0;
            animation: speedline var(--sd, 0.8s) ease-in-out infinite;
            z-index: 2;
        }
        @keyframes speedline {
            0%,100% { opacity: 0; transform: scaleY(0); }
            50%      { opacity: 0.15; transform: scaleY(1); }
        }

        /* Glow floor */
        .floor-glow {
            position: fixed;
            bottom: -60px; left: 50%;
            transform: translateX(-50%);
            width: 600px; height: 120px;
            background: radial-gradient(ellipse, var(--red) 0%, transparent 70%);
            opacity: 0.18;
            filter: blur(20px);
            z-index: 2;
            animation: flicker 2s ease-in-out infinite alternate;
        }
        @keyframes flicker { from { opacity:0.12; } to { opacity:0.22; } }

        /* ── CARD ── */
        .card-wrap {
            position: relative; z-index: 10;
            width: 100%; max-width: 440px;
            padding: 0 20px;
        }

        /* Top logo bar */
        .logo-bar {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 28px;
            justify-content: center;
        }
        .logo-icon {
            font-size: 36px;
            filter: drop-shadow(0 0 10px var(--orange));
            animation: bob 2s ease-in-out infinite alternate;
        }
        @keyframes bob { from { transform: translateY(0); } to { transform: translateY(-5px); } }

        .logo-text {
            font-family: 'Orbitron', monospace;
            font-size: 15px;
            font-weight: 900;
            letter-spacing: 3px;
            color: var(--text);
            text-transform: uppercase;
            line-height: 1.2;
        }
        .logo-text span {
            display: block;
            font-size: 10px;
            color: var(--orange);
            letter-spacing: 6px;
        }

        .card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 4px;
            padding: 40px 36px 36px;
            position: relative;
            overflow: hidden;
            box-shadow:
                0 0 0 1px #ffffff08,
                0 30px 80px #00000088,
                inset 0 1px 0 #ffffff0a;
        }

        /* Corner accents */
        .card::before, .card::after {
            content: '';
            position: absolute;
            width: 28px; height: 28px;
            border-color: var(--red);
            border-style: solid;
        }
        .card::before { top: -1px; left: -1px; border-width: 2px 0 0 2px; }
        .card::after  { bottom: -1px; right: -1px; border-width: 0 2px 2px 0; }

        /* Scan line shimmer */
        .card-shine {
            position: absolute;
            top: -100%; left: 0; right: 0;
            height: 60%;
            background: linear-gradient(180deg, transparent, rgba(255,100,0,0.04), transparent);
            animation: scan 4s ease-in-out infinite;
            pointer-events: none;
        }
        @keyframes scan { 0%,100% { top:-60%; } 50% { top:150%; } }

        /* Title */
        .card-title {
            font-family: 'Orbitron', monospace;
            font-size: 22px;
            font-weight: 900;
            letter-spacing: 4px;
            text-transform: uppercase;
            color: #fff;
            text-align: center;
            margin-bottom: 6px;
        }
        .card-sub {
            text-align: center;
            color: var(--muted);
            font-size: 13px;
            letter-spacing: 2px;
            text-transform: uppercase;
            margin-bottom: 32px;
        }

        /* Divider */
        .divider {
            display: flex; align-items: center; gap: 12px;
            margin-bottom: 28px;
        }
        .divider::before, .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: linear-gradient(90deg, transparent, var(--red), transparent);
        }
        .divider-icon { color: var(--orange); font-size: 14px; }

        /* Alert */
        .alert {
            padding: 10px 14px;
            border-radius: 3px;
            font-size: 13px;
            letter-spacing: 0.5px;
            margin-bottom: 20px;
            font-weight: 600;
        }
        .alert-error   { background: #ff220015; border: 1px solid #ff220044; color: #ff6644; }
        .alert-success { background: #00ff4415; border: 1px solid #00ff4444; color: #44ff88; }

        /* Form */
        .field { margin-bottom: 20px; position: relative; }

        .field label {
            display: block;
            font-size: 11px;
            letter-spacing: 3px;
            text-transform: uppercase;
            color: var(--orange);
            margin-bottom: 8px;
            font-weight: 600;
        }

        .field-inner {
            position: relative;
            display: flex; align-items: center;
        }
        .field-icon {
            position: absolute; left: 14px;
            color: var(--muted); font-size: 16px;
            pointer-events: none;
            transition: color 0.2s;
        }

        .field input {
            width: 100%;
            background: #13171f;
            border: 1px solid #2a2f3d;
            border-radius: 3px;
            padding: 13px 14px 13px 42px;
            color: var(--text);
            font-family: 'Rajdhani', sans-serif;
            font-size: 15px;
            font-weight: 500;
            letter-spacing: 0.5px;
            outline: none;
            transition: border-color 0.25s, box-shadow 0.25s, background 0.25s;
        }
        .field input::placeholder { color: #3a4055; }
        .field input:focus {
            border-color: var(--orange);
            background: #161b26;
            box-shadow: 0 0 0 3px #ff770015, inset 0 0 20px #ff770008;
        }
        .field input:focus + .field-icon,
        .field-inner:focus-within .field-icon { color: var(--orange); }

        /* Progress bar under input */
        .field-bar {
            position: absolute; bottom: 0; left: 0;
            height: 2px; width: 0;
            background: linear-gradient(90deg, var(--red), var(--orange));
            transition: width 0.3s ease;
            border-radius: 0 0 3px 3px;
        }
        .field input:focus ~ .field-bar { width: 100%; }

        /* Submit button */
        .btn-submit {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, var(--red) 0%, #cc1100 50%, #aa0000 100%);
            color: #fff;
            border: none;
            border-radius: 3px;
            font-family: 'Orbitron', monospace;
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 4px;
            text-transform: uppercase;
            cursor: pointer;
            position: relative;
            overflow: hidden;
            transition: transform 0.15s, box-shadow 0.15s;
            margin-top: 8px;
            box-shadow: 0 4px 24px #ff220033, inset 0 1px 0 #ffffff22;
        }
        .btn-submit::before {
            content: '';
            position: absolute; inset: 0;
            background: linear-gradient(135deg, transparent 40%, rgba(255,255,255,0.12), transparent 60%);
            transform: translateX(-100%);
            transition: transform 0.5s;
        }
        .btn-submit:hover::before { transform: translateX(100%); }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 32px #ff220055, inset 0 1px 0 #ffffff22;
        }
        .btn-submit:active { transform: translateY(0); }

        /* Footer links */
        .card-footer {
            margin-top: 24px;
            text-align: center;
            font-size: 13px;
            color: var(--muted);
            letter-spacing: 0.5px;
        }
        .card-footer a {
            color: var(--orange);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s;
        }
        .card-footer a:hover { color: var(--yellow); }

        .back-link {
            display: flex; align-items: center; justify-content: center;
            gap: 8px; margin-top: 16px;
            font-family: 'Orbitron', monospace;
            font-size: 11px; letter-spacing: 2px;
            text-transform: uppercase;
            color: var(--muted);
            text-decoration: none;
            padding: 11px 20px;
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 3px;
            background: rgba(255,255,255,0.03);
            transition: all 0.2s;
        }
        .back-link:hover {
            color: #fff;
            border-color: rgba(255,100,0,0.35);
            background: rgba(255,80,0,0.08);
            transform: translateY(-1px);
        }
        .back-arrow {
            font-size: 14px;
            transition: transform 0.2s;
        }
        .back-link:hover .back-arrow { transform: translateX(-3px); }

        /* Top-left home button (fixed) */
        .home-btn {
            position: fixed; top: 20px; left: 20px; z-index: 50;
            display: flex; align-items: center; gap: 7px;
            font-family: 'Orbitron', monospace;
            font-size: 10px; font-weight: 700;
            letter-spacing: 2px; text-transform: uppercase;
            color: rgba(255,255,255,0.45);
            text-decoration: none;
            padding: 9px 16px;
            border: 1px solid rgba(255,100,0,0.2);
            border-radius: 3px;
            background: rgba(0,0,0,0.4);
            backdrop-filter: blur(8px);
            transition: all 0.2s;
        }
        .home-btn:hover {
            color: #fff;
            border-color: rgba(255,100,0,0.5);
            background: rgba(255,60,0,0.12);
            transform: translateY(-1px);
        }
        .home-btn-icon { font-size: 13px; }

        /* Animated border glow */
        @keyframes borderPulse {
            0%,100% { box-shadow: 0 0 0 1px #ffffff08, 0 30px 80px #00000088, 0 0 30px #ff220011; }
            50%      { box-shadow: 0 0 0 1px #ffffff08, 0 30px 80px #00000088, 0 0 50px #ff220028; }
        }
        .card { animation: borderPulse 3s ease-in-out infinite; }

        /* Checkered flag strip at top of card */
        .flag-strip {
            height: 4px;
            background: repeating-linear-gradient(
                90deg,
                var(--red) 0px, var(--red) 12px,
                transparent 12px, transparent 24px
            );
            margin-bottom: 28px;
            opacity: 0.8;
        }

        /* RPM meter decoration */
        .rpm-bar {
            display: flex; gap: 3px; margin: 20px 0 0;
            justify-content: center;
        }
        .rpm-seg {
            width: 18px; height: 5px; border-radius: 1px;
            background: #1a1f2e;
            animation: rpmPulse var(--rp, 1s) ease-in-out infinite alternate;
        }
        .rpm-seg.active { background: var(--red); }
        .rpm-seg.mid    { background: var(--orange); }
        .rpm-seg.low    { background: var(--yellow); }
        @keyframes rpmPulse { from { opacity:0.4; } to { opacity:1; } }
    </style>
</head>
<body>

<!-- Top-left Home Button -->
<a class="home-btn" href="index.html">
    <span class="home-btn-icon">🏠</span> Home
</a>

<div class="bg"></div>
<div class="stars" id="stars"></div>
<div class="road-wrap">
    <div class="road"></div>
    <div class="road-line" style="--dur:0.9s; left:46%"></div>
    <div class="road-line" style="--dur:1.1s; left:50%; animation-delay:0.3s"></div>
    <div class="road-line" style="--dur:1.0s; left:54%; animation-delay:0.6s"></div>
</div>
<div class="speed-line" style="left:15%; --sd:1.1s;"></div>
<div class="speed-line" style="left:82%; --sd:0.9s; animation-delay:0.4s;"></div>
<div class="speed-line" style="left:6%;  --sd:1.4s; animation-delay:0.8s;"></div>
<div class="speed-line" style="left:93%; --sd:1.2s; animation-delay:1.1s;"></div>
<div class="floor-glow"></div>

<div class="card-wrap">
    <div class="logo-bar">
        <div class="logo-icon">🏎️</div>
        <div class="logo-text">
             Narayan's Turbo Racing
            <span>3D Edition</span>
        </div>
    </div>

    <div class="card">
        <div class="card-shine"></div>
        <div class="flag-strip"></div>

        <div class="card-title">Driver Login</div>
        <div class="card-sub">Enter your credentials to race</div>

        <div class="divider"><span class="divider-icon">⚡</span></div>

        <% if (error != null) { %>
        <div class="alert alert-error">⚠ <%= error %></div>
        <% } %>
        <% if (success != null) { %>
        <div class="alert alert-success">✔ <%= success %></div>
        <% } %>

        <form action="login" method="post" autocomplete="off">

            <div class="field">
                <label for="username">Username</label>
                <div class="field-inner">
                    <span class="field-icon">👤</span>
                    <input type="text" id="username" name="username"
                           placeholder="Enter your username" required
                           autocomplete="username">
                    <div class="field-bar"></div>
                </div>
            </div>

            <div class="field">
                <label for="password">Password</label>
                <div class="field-inner">
                    <span class="field-icon">🔒</span>
                    <input type="password" id="password" name="password"
                           placeholder="Enter your password" required
                           autocomplete="current-password">
                    <div class="field-bar"></div>
                </div>
            </div>

            <button type="submit" class="btn-submit">▶ Start Engine</button>
        </form>

        <div class="rpm-bar" id="rpm"></div>
    </div>

    <div class="card-footer">
        New driver? <a href="register.jsp">Register Now</a>
    </div>
    <a class="back-link" href="index.html">
        <span class="back-arrow">←</span> Back to Main Menu
    </a>
</div>

<script>
// Stars
const starsEl = document.getElementById('stars');
for (let i = 0; i < 120; i++) {
    const s = document.createElement('div');
    s.className = 'star';
    const sz = 0.5 + Math.random() * 1.5;
    s.style.cssText = `
        left:${Math.random()*100}%;
        top:${Math.random()*100}%;
        width:${sz}px; height:${sz}px;
        --d:${2+Math.random()*3}s;
        animation-delay:${Math.random()*3}s;
    `;
    starsEl.appendChild(s);
}

// RPM bar animation
const rpmEl = document.getElementById('rpm');
const segs = 14;
for (let i = 0; i < segs; i++) {
    const seg = document.createElement('div');
    seg.className = 'rpm-seg ' + (i < 6 ? 'low' : i < 10 ? 'mid' : 'active');
    seg.style.cssText = `--rp:${0.6+i*0.08}s; animation-delay:${i*0.06}s;`;
    rpmEl.appendChild(seg);
}

// Button rev sound simulation (visual pulse)
document.querySelector('.btn-submit').addEventListener('mouseenter', function() {
    this.style.letterSpacing = '5px';
    setTimeout(() => this.style.letterSpacing = '4px', 150);
});
</script>
</body>
</html>
