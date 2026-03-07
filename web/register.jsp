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
    <title>Register — 3D Car Racing Arena</title>
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&family=Rajdhani:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --red:    #ff2200;
            --orange: #ff7700;
            --yellow: #ffcc00;
            --green:  #00ff88;
            --dark:   #080a10;
            --card:   #0d1018;
            --border: #ff220033;
            --text:   #e8eaf0;
            --muted:  #667088;
        }

        *, *::before, *::after { margin:0; padding:0; box-sizing:border-box; }

        body {
            font-family: 'Rajdhani', sans-serif;
            background: var(--dark);
            color: var(--text);
            min-height: 100vh;
            overflow-x: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px 0;
        }

        /* ── BACKGROUND ── */
        .bg { position:fixed; inset:0; z-index:0;
            background: linear-gradient(180deg, #000510 0%, #050a18 40%, #0a0808 100%); }

        .stars { position:fixed; inset:0; z-index:1; overflow:hidden; }
        .star { position:absolute; background:#fff; border-radius:50%;
            animation: twinkle var(--d,3s) ease-in-out infinite alternate; }
        @keyframes twinkle { from{opacity:0.1} to{opacity:0.9} }

        /* Diagonal speed stripes */
        .stripes {
            position: fixed; inset: 0; z-index: 1; pointer-events: none;
            background: repeating-linear-gradient(
                -55deg,
                transparent 0px,
                transparent 80px,
                rgba(255,34,0,0.025) 80px,
                rgba(255,34,0,0.025) 82px
            );
        }

        /* Animated corner beams */
        .beam {
            position: fixed; z-index: 2; pointer-events: none;
            width: 2px; height: 60vh;
            background: linear-gradient(180deg, var(--orange), transparent);
            opacity: 0.18;
            animation: beamMove var(--bm, 3s) ease-in-out infinite alternate;
        }
        .beam-tl { top:0; left:20%; transform-origin: top; transform: rotate(15deg); }
        .beam-tr { top:0; right:20%; transform-origin: top; transform: rotate(-15deg); --bm:2.5s; }
        @keyframes beamMove { from{opacity:0.08} to{opacity:0.22} }

        /* Floor glow */
        .floor-glow {
            position: fixed; bottom:-80px; left:50%;
            transform: translateX(-50%);
            width: 700px; height: 140px;
            background: radial-gradient(ellipse, #ff4400 0%, transparent 70%);
            opacity: 0.14; filter: blur(25px);
            z-index: 2; animation: flicker 2.5s ease-in-out infinite alternate;
        }
        @keyframes flicker { from{opacity:0.09} to{opacity:0.2} }

        /* ── CARD ── */
        .card-wrap {
            position: relative; z-index: 10;
            width: 100%; max-width: 460px;
            padding: 0 20px;
        }

        .logo-bar {
            display:flex; align-items:center; gap:14px;
            margin-bottom:24px; justify-content:center;
        }
        .logo-icon { font-size:36px; filter:drop-shadow(0 0 10px var(--orange));
            animation: bob 2s ease-in-out infinite alternate; }
        @keyframes bob { from{transform:translateY(0)} to{transform:translateY(-5px)} }

        .logo-text { font-family:'Orbitron',monospace; font-size:15px;
            font-weight:900; letter-spacing:3px; color:var(--text);
            text-transform:uppercase; line-height:1.2; }
        .logo-text span { display:block; font-size:10px; color:var(--orange); letter-spacing:6px; }

        .card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 4px;
            padding: 36px 36px 32px;
            position: relative; overflow: hidden;
            box-shadow: 0 0 0 1px #ffffff08, 0 30px 80px #00000088,
                        inset 0 1px 0 #ffffff0a;
            animation: borderPulse 3s ease-in-out infinite;
        }
        @keyframes borderPulse {
            0%,100% { box-shadow: 0 0 0 1px #ffffff08,0 30px 80px #00000088,0 0 30px #ff220011; }
            50%      { box-shadow: 0 0 0 1px #ffffff08,0 30px 80px #00000088,0 0 50px #ff220028; }
        }
        .card::before,.card::after { content:''; position:absolute;
            width:28px; height:28px; border-color:var(--orange); border-style:solid; }
        .card::before { top:-1px; left:-1px; border-width:2px 0 0 2px; }
        .card::after  { bottom:-1px; right:-1px; border-width:0 2px 2px 0; }

        .card-shine { position:absolute; top:-100%; left:0; right:0;
            height:60%; background:linear-gradient(180deg,transparent,rgba(255,120,0,0.04),transparent);
            animation:scan 5s ease-in-out infinite; pointer-events:none; }
        @keyframes scan { 0%,100%{top:-60%} 50%{top:150%} }

        /* Checkered flag */
        .flag-strip {
            height: 4px; margin-bottom: 24px;
            background: repeating-linear-gradient(90deg,
                var(--orange) 0px, var(--orange) 12px, transparent 12px, transparent 24px);
        }

        .card-title { font-family:'Orbitron',monospace; font-size:20px; font-weight:900;
            letter-spacing:4px; text-transform:uppercase; color:#fff;
            text-align:center; margin-bottom:4px; }
        .card-sub { text-align:center; color:var(--muted); font-size:12px;
            letter-spacing:2px; text-transform:uppercase; margin-bottom:24px; }

        .divider { display:flex; align-items:center; gap:12px; margin-bottom:24px; }
        .divider::before,.divider::after { content:''; flex:1; height:1px;
            background:linear-gradient(90deg,transparent,var(--orange),transparent); }
        .divider-icon { color:var(--orange); font-size:14px; }

        /* Alert */
        .alert { padding:10px 14px; border-radius:3px; font-size:13px;
            letter-spacing:.5px; margin-bottom:16px; font-weight:600; }
        .alert-error   { background:#ff220015; border:1px solid #ff220044; color:#ff6644; }
        .alert-success { background:#00ff4415; border:1px solid #00ff4444; color:#44ff88; }

        /* Fields */
        .fields-grid { display:grid; grid-template-columns:1fr 1fr; gap:0 16px; }
        .field { margin-bottom:18px; position:relative; }
        .field.full { grid-column: span 2; }

        .field label { display:block; font-size:10px; letter-spacing:3px;
            text-transform:uppercase; color:var(--orange); margin-bottom:7px; font-weight:600; }

        .field-inner { position:relative; display:flex; align-items:center; }
        .field-icon { position:absolute; left:13px; color:var(--muted); font-size:15px;
            pointer-events:none; transition:color .2s; z-index:1; }

        .field input {
            width:100%; background:#13171f;
            border:1px solid #2a2f3d; border-radius:3px;
            padding:12px 12px 12px 40px;
            color:var(--text); font-family:'Rajdhani',sans-serif;
            font-size:14px; font-weight:500; letter-spacing:.5px;
            outline:none; transition:border-color .25s,box-shadow .25s,background .25s;
        }
        .field input::placeholder { color:#3a4055; }
        .field input:focus {
            border-color:var(--orange); background:#161b26;
            box-shadow: 0 0 0 3px #ff770015, inset 0 0 20px #ff770008;
        }
        .field-inner:focus-within .field-icon { color:var(--orange); }

        .field-bar { position:absolute; bottom:0; left:0; height:2px; width:0;
            background:linear-gradient(90deg,var(--red),var(--orange));
            transition:width .3s; border-radius:0 0 3px 3px; }
        .field input:focus ~ .field-bar { width:100%; }

        /* Password strength */
        .strength-wrap { margin-top:6px; display:none; }
        .strength-wrap.visible { display:block; }
        .strength-bar { display:flex; gap:4px; margin-bottom:4px; }
        .strength-seg { flex:1; height:3px; border-radius:1px; background:#1a1f2e; transition:background .3s; }
        .strength-label { font-size:10px; letter-spacing:2px; text-transform:uppercase; color:var(--muted); }

        /* Submit */
        .btn-submit {
            width:100%; padding:14px;
            background:linear-gradient(135deg,var(--orange) 0%,#cc5500 50%,#aa3300 100%);
            color:#fff; border:none; border-radius:3px;
            font-family:'Orbitron',monospace; font-size:12px; font-weight:700;
            letter-spacing:4px; text-transform:uppercase; cursor:pointer;
            position:relative; overflow:hidden;
            transition:transform .15s,box-shadow .15s;
            margin-top:6px;
            box-shadow:0 4px 24px #ff770033,inset 0 1px 0 #ffffff22;
        }
        .btn-submit::before { content:''; position:absolute; inset:0;
            background:linear-gradient(135deg,transparent 40%,rgba(255,255,255,0.12),transparent 60%);
            transform:translateX(-100%); transition:transform .5s; }
        .btn-submit:hover::before { transform:translateX(100%); }
        .btn-submit:hover { transform:translateY(-2px);
            box-shadow:0 8px 32px #ff770055,inset 0 1px 0 #ffffff22; }
        .btn-submit:active { transform:translateY(0); }

        /* Progress steps */
        .reg-steps {
            display:flex; gap:0; margin-bottom:20px; border-radius:3px; overflow:hidden;
        }
        .step {
            flex:1; padding:7px 0; text-align:center;
            font-family:'Orbitron',monospace; font-size:9px; letter-spacing:2px;
            font-weight:700; text-transform:uppercase;
            background:#13171f; color:var(--muted);
            transition:all .3s; position:relative;
        }
        .step.active { background:linear-gradient(135deg,#ff2200,#ff7700); color:#fff; }
        .step-num { display:block; font-size:14px; margin-bottom:2px; }

        .card-footer { margin-top:20px; text-align:center; font-size:13px;
            color:var(--muted); letter-spacing:.5px; }
        .card-footer a { color:var(--red); text-decoration:none; font-weight:600;
            transition:color .2s; }
        .card-footer a:hover { color:var(--orange); }

        .back-link { display:flex; align-items:center; justify-content:center;
            gap:6px; margin-top:14px; font-size:12px; letter-spacing:2px;
            text-transform:uppercase; color:var(--muted);
            text-decoration:none; transition:color .2s; }
        .back-link:hover { color:var(--text); }
    </style>
</head>
<body>

<div class="bg"></div>
<div class="stars" id="stars"></div>
<div class="stripes"></div>
<div class="beam beam-tl"></div>
<div class="beam beam-tr"></div>
<div class="floor-glow"></div>

<div class="card-wrap">
    <div class="logo-bar">
        <div class="logo-icon">🏁</div>
        <div class="logo-text">
            Narayan's Turbo Racing
            <span>Create Your Profile</span>
        </div>
    </div>

    <div class="card">
        <div class="card-shine"></div>
        <div class="flag-strip"></div>

        <!-- Steps -->
        <div class="reg-steps">
            <div class="step active"><span class="step-num">01</span>Profile</div>
            <div class="step"><span class="step-num">02</span>Security</div>
            <div class="step"><span class="step-num">03</span>Race!</div>
        </div>

        <div class="card-title">New Driver</div>
        <div class="card-sub">Register to join the Narayan's</div>
        <div class="divider"><span class="divider-icon">🏆</span></div>

        <% if (error != null) { %>
        <div class="alert alert-error">⚠ <%= error %></div>
        <% } %>
        <% if (success != null) { %>
        <div class="alert alert-success">✔ <%= success %></div>
        <% } %>

        <form action="register" method="post" autocomplete="off" id="regForm">
            <div class="fields-grid">

                <div class="field full">
                    <label for="username">Driver Name</label>
                    <div class="field-inner">
                        <span class="field-icon">🎮</span>
                        <input type="text" id="username" name="username"
                               placeholder="Choose your driver name" required
                               minlength="3" autocomplete="off">
                        <div class="field-bar"></div>
                    </div>
                </div>

                <div class="field full">
                    <label for="email">Email Address</label>
                    <div class="field-inner">
                        <span class="field-icon">📧</span>
                        <input type="email" id="email" name="email"
                               placeholder="your@email.com" required
                               autocomplete="off">
                        <div class="field-bar"></div>
                    </div>
                </div>

                <div class="field full">
                    <label for="password">Password</label>
                    <div class="field-inner">
                        <span class="field-icon">🔑</span>
                        <input type="password" id="password" name="password"
                               placeholder="Create a strong password" required
                               minlength="6" autocomplete="new-password"
                               oninput="checkStrength(this.value)">
                        <div class="field-bar"></div>
                    </div>
                    <div class="strength-wrap" id="strengthWrap">
                        <div class="strength-bar">
                            <div class="strength-seg" id="s1"></div>
                            <div class="strength-seg" id="s2"></div>
                            <div class="strength-seg" id="s3"></div>
                            <div class="strength-seg" id="s4"></div>
                        </div>
                        <div class="strength-label" id="strengthLabel">Weak</div>
                    </div>
                </div>

                <div class="field full">
                    <label for="confirmPassword">Confirm Password</label>
                    <div class="field-inner">
                        <span class="field-icon">🔒</span>
                        <input type="password" id="confirmPassword" name="confirmPassword"
                               placeholder="Repeat your password" required
                               autocomplete="new-password"
                               oninput="checkMatch()">
                        <div class="field-bar"></div>
                    </div>
                    <div id="matchMsg" style="font-size:11px;margin-top:5px;letter-spacing:1px;display:none;"></div>
                </div>

            </div>

            <button type="submit" class="btn-submit" id="submitBtn">▶▶ Enter the Narayan's</button>
        </form>

        <div class="card-footer">
            Already have an account? <a href="login.jsp">Login Here</a>
        </div>
    </div>

    <a class="back-link" href="index.html">← Back to Main Menu</a>
</div>

<script>
// Stars
const starsEl = document.getElementById('stars');
for (let i = 0; i < 130; i++) {
    const s = document.createElement('div');
    s.className = 'star';
    const sz = 0.5 + Math.random() * 1.5;
    s.style.cssText = `left:${Math.random()*100}%;top:${Math.random()*100}%;
        width:${sz}px;height:${sz}px;--d:${2+Math.random()*3}s;
        animation-delay:${Math.random()*3}s;`;
    starsEl.appendChild(s);
}

// Password strength
function checkStrength(val) {
    const wrap = document.getElementById('strengthWrap');
    const label = document.getElementById('strengthLabel');
    wrap.className = 'strength-wrap visible';
    const segs = [document.getElementById('s1'),document.getElementById('s2'),
                  document.getElementById('s3'),document.getElementById('s4')];
    segs.forEach(s => s.style.background = '#1a1f2e');

    let score = 0;
    if (val.length >= 6)  score++;
    if (val.length >= 10) score++;
    if (/[A-Z]/.test(val) && /[0-9]/.test(val)) score++;
    if (/[^A-Za-z0-9]/.test(val)) score++;

    const colors  = ['#ff2200','#ff7700','#ffcc00','#00ff88'];
    const labels  = ['Weak','Medium','Strong','Max Speed!'];

    for (let i = 0; i < score; i++) segs[i].style.background = colors[score-1];
    label.textContent = labels[Math.max(0,score-1)];
    label.style.color  = colors[Math.max(0,score-1)];
}

// Confirm match
function checkMatch() {
    const p1 = document.getElementById('password').value;
    const p2 = document.getElementById('confirmPassword').value;
    const msg = document.getElementById('matchMsg');
    if (!p2) { msg.style.display='none'; return; }
    msg.style.display = 'block';
    if (p1 === p2) {
        msg.textContent = '✔ Passwords match — ready to race!';
        msg.style.color = '#00ff88';
    } else {
        msg.textContent = '✘ Passwords do not match';
        msg.style.color = '#ff4422';
    }
}

// Step animation on input focus
document.getElementById('email').addEventListener('focus', () => {
    document.querySelectorAll('.step')[1].classList.add('active');
});
document.getElementById('password').addEventListener('focus', () => {
    document.querySelectorAll('.step')[2].classList.add('active');
});
</script>
</body>
</html>
