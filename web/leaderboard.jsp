<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="database.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Leaderboard — 3D Car Racing Arena</title>
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&family=Rajdhani:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { background:#0a0a0f; color:#fff; font-family:'Rajdhani',Arial,sans-serif; min-height:100vh; overflow-x:hidden; }

        .bg-grid {
            position:fixed; inset:0; z-index:0;
            background: linear-gradient(rgba(255,100,0,0.04) 1px, transparent 1px),
                        linear-gradient(90deg, rgba(255,100,0,0.04) 1px, transparent 1px);
            background-size:40px 40px;
            animation:gridMove 8s linear infinite;
        }
        @keyframes gridMove { from{background-position:0 0} to{background-position:0 40px} }
        .bg-glow {
            position:fixed; top:-200px; left:50%; transform:translateX(-50%);
            width:800px; height:400px; z-index:0;
            background:radial-gradient(ellipse, rgba(255,80,0,0.12) 0%, transparent 70%);
            pointer-events:none;
        }

        .page { position:relative; z-index:1; max-width:900px; margin:0 auto; padding:32px 20px 60px; }

        .nav { display:flex; justify-content:space-between; align-items:center; margin-bottom:32px; }
        .nav-btn {
            padding:10px 22px; border-radius:4px; font-family:'Orbitron',sans-serif;
            font-size:12px; font-weight:700; letter-spacing:2px; cursor:pointer;
            text-decoration:none; border:1px solid rgba(255,100,0,0.4);
            color:#ff7700; background:rgba(255,80,0,0.08); transition:all 0.2s;
        }
        .nav-btn:hover { background:rgba(255,80,0,0.2); color:#fff; transform:translateY(-1px); }
        .nav-btn.play { background:linear-gradient(135deg,#ff2200,#ff7700); color:#fff; border:none; box-shadow:0 4px 20px rgba(255,34,0,0.4); }
        .nav-btn.play:hover { box-shadow:0 6px 28px rgba(255,34,0,0.6); }

        .header { text-align:center; margin-bottom:36px; }
        .trophy { font-size:64px; animation:bob 2s ease-in-out infinite; display:block; margin-bottom:8px; }
        @keyframes bob { 0%,100%{transform:translateY(0)} 50%{transform:translateY(-8px)} }
        .title { font-family:'Orbitron',sans-serif; font-size:46px; font-weight:900; letter-spacing:4px; color:#fff; text-shadow:0 0 30px rgba(255,100,0,0.7); margin-bottom:6px; }
        .subtitle { color:#ff7700; font-size:14px; letter-spacing:6px; text-transform:uppercase; }

        .stats { display:flex; background:rgba(255,255,255,0.03); border:1px solid rgba(255,100,0,0.2); border-radius:8px; overflow:hidden; margin-bottom:32px; }
        .stat { flex:1; padding:18px; text-align:center; border-right:1px solid rgba(255,100,0,0.15); }
        .stat:last-child { border-right:none; }
        .stat-val { font-family:'Orbitron',sans-serif; font-size:28px; font-weight:900; color:#ff7700; display:block; margin-bottom:4px; }
        .stat-lbl { font-size:11px; letter-spacing:4px; color:#666; text-transform:uppercase; }

        .podium { display:flex; align-items:flex-end; justify-content:center; gap:16px; margin-bottom:36px; }
        .podium-card { flex:1; max-width:200px; text-align:center; background:rgba(255,255,255,0.04); border-radius:10px; overflow:hidden; transition:transform 0.2s; }
        .podium-card:hover { transform:translateY(-4px); }
        .podium-card.first  { border:1px solid rgba(255,200,0,0.5); box-shadow:0 0 30px rgba(255,180,0,0.15); order:2; }
        .podium-card.second { border:1px solid rgba(180,180,180,0.4); order:1; }
        .podium-card.third  { border:1px solid rgba(180,100,40,0.4); order:3; }
        .podium-top { padding:16px 12px 8px; background:linear-gradient(to bottom, rgba(255,255,255,0.05), transparent); }
        .podium-medal { font-size:32px; display:block; margin-bottom:6px; }
        .podium-medal.spin { animation:crownSpin 3s ease-in-out infinite; }
        @keyframes crownSpin { 0%,100%{transform:rotate(-5deg)} 50%{transform:rotate(5deg) scale(1.1)} }
        .podium-name { font-family:'Orbitron',sans-serif; font-size:13px; font-weight:700; color:#fff; word-break:break-all; margin-bottom:4px; }
        .podium-score { font-family:'Orbitron',sans-serif; font-size:20px; font-weight:900; margin-bottom:8px; }
        .gold-clr   { color:#ffcc00; text-shadow:0 0 15px rgba(255,200,0,0.6); }
        .silver-clr { color:#c8c8c8; }
        .bronze-clr { color:#cd7f32; }
        .podium-base { padding:10px; }
        .podium-base.g { background:rgba(255,200,0,0.12); }
        .podium-base.s { background:rgba(180,180,180,0.08); }
        .podium-base.b { background:rgba(180,100,40,0.08); }
        .podium-rank-label { font-family:'Orbitron',sans-serif; font-size:11px; font-weight:700; letter-spacing:2px; }

        .table-wrap { background:rgba(255,255,255,0.02); border:1px solid rgba(255,100,0,0.15); border-radius:8px; overflow:hidden; }
        .table-header {
            display:grid; grid-template-columns:60px 1fr 180px 100px;
            padding:14px 20px; background:rgba(255,80,0,0.1);
            border-bottom:1px solid rgba(255,100,0,0.2);
            font-family:'Orbitron',sans-serif; font-size:11px; font-weight:700; letter-spacing:3px; color:#ff7700; text-transform:uppercase;
        }
        .table-row {
            display:grid; grid-template-columns:60px 1fr 180px 100px;
            padding:14px 20px; align-items:center;
            border-bottom:1px solid rgba(255,255,255,0.04); transition:background 0.2s;
        }
        .table-row:last-child { border-bottom:none; }
        .table-row:hover { background:rgba(255,100,0,0.06); }
        .tr1 { background:rgba(255,200,0,0.05); }
        .tr2 { background:rgba(180,180,180,0.03); }
        .tr3 { background:rgba(180,100,40,0.03); }

        .rank-badge { font-family:'Orbitron',sans-serif; font-weight:900; font-size:14px; text-align:center; }
        .rk1 { color:#ffcc00; } .rk2 { color:#c8c8c8; } .rk3 { color:#cd7f32; } .rkn { color:#555; }
        .driver-cell { display:flex; align-items:center; gap:12px; }
        .driver-avatar { width:32px; height:32px; border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:14px; font-weight:bold; flex-shrink:0; }
        .driver-name { font-size:16px; font-weight:600; color:#eee; }
        .progress-wrap { padding-right:16px; }
        .progress-bar-bg { height:6px; background:rgba(255,255,255,0.08); border-radius:3px; overflow:hidden; }
        .progress-bar-fill { height:100%; border-radius:3px; background:linear-gradient(90deg,#ff2200,#ff9900); }
        .progress-bar-fill.top-bar { background:linear-gradient(90deg,#ffcc00,#ff7700); }
        .score-val { font-family:'Orbitron',sans-serif; font-size:16px; font-weight:900; color:#ff7700; text-align:right; }
        .sv1{color:#ffcc00;} .sv2{color:#c8c8c8;} .sv3{color:#cd7f32;}

        .empty-state { text-align:center; padding:80px 20px; color:#444; font-size:18px; letter-spacing:3px; }
        .empty-icon { font-size:64px; display:block; margin-bottom:16px; opacity:0.4; }
        .footer { text-align:center; margin-top:48px; color:#333; font-size:12px; letter-spacing:4px; text-transform:uppercase; }
        .footer-flags { font-size:20px; display:block; margin-bottom:8px; }
    </style>
</head>
<body>
<div class="bg-grid"></div>
<div class="bg-glow"></div>

<%
    int totalDrivers = 0, topScore = 0;
    java.util.List<String[]> rows = new java.util.ArrayList<>();
    try {
        Connection con = DBConnection.getConnection();
        ResultSet c = con.createStatement().executeQuery("SELECT COUNT(*) FROM scores");
        if (c.next()) totalDrivers = c.getInt(1);
        ResultSet t = con.createStatement().executeQuery("SELECT MAX(score) FROM scores");
        if (t.next()) topScore = t.getInt(1);
        PreparedStatement ps = con.prepareStatement("SELECT username, score FROM scores ORDER BY score DESC LIMIT 20");
        ResultSet rs = ps.executeQuery();
        while (rs.next()) rows.add(new String[]{ rs.getString("username"), String.valueOf(rs.getInt("score")) });
    } catch (Exception e) { out.println("<!-- DB Error: " + e.getMessage() + " -->"); }
%>

<div class="page">
    <nav class="nav">
        <a href="index.html" class="nav-btn">← MENU</a>
        <a href="game.jsp" class="nav-btn play">PLAY ▶</a>
    </nav>

    <div class="header">
        <span class="trophy">🏆</span>
        <div class="title">Leaderboard</div>
        <div class="subtitle">Top Drivers · All Time</div>
    </div>

    <div class="stats">
        <div class="stat"><span class="stat-val"><%= totalDrivers %></span><span class="stat-lbl">Drivers</span></div>
        <div class="stat"><span class="stat-val"><%= topScore %></span><span class="stat-lbl">Top Score</span></div>
        <div class="stat"><span class="stat-val">3D</span><span class="stat-lbl">Arena</span></div>
    </div>

    <% if (rows.isEmpty()) { %>
    <div class="empty-state">
        <span class="empty-icon">🏁</span>
        NO SCORES YET — BE THE FIRST TO RACE!
    </div>
    <% } else { %>

    <!-- PODIUM -->
    <div class="podium">
        <% if (rows.size() >= 1) { %>
        <div class="podium-card first">
            <div class="podium-top">
                <span class="podium-medal spin">👑</span>
                <div class="podium-name"><%= rows.get(0)[0] %></div>
                <div class="podium-score gold-clr"><%= rows.get(0)[1] %></div>
            </div>
            <div class="podium-base g"><span class="podium-rank-label gold-clr">1st Place</span></div>
        </div>
        <% } if (rows.size() >= 2) { %>
        <div class="podium-card second">
            <div class="podium-top">
                <span class="podium-medal">🥈</span>
                <div class="podium-name"><%= rows.get(1)[0] %></div>
                <div class="podium-score silver-clr"><%= rows.get(1)[1] %></div>
            </div>
            <div class="podium-base s"><span class="podium-rank-label silver-clr">2nd Place</span></div>
        </div>
        <% } if (rows.size() >= 3) { %>
        <div class="podium-card third">
            <div class="podium-top">
                <span class="podium-medal">🥉</span>
                <div class="podium-name"><%= rows.get(2)[0] %></div>
                <div class="podium-score bronze-clr"><%= rows.get(2)[1] %></div>
            </div>
            <div class="podium-base b"><span class="podium-rank-label bronze-clr">3rd Place</span></div>
        </div>
        <% } %>
    </div>

    <!-- TABLE -->
    <div class="table-wrap">
        <div class="table-header">
            <div>Rank</div><div>Driver</div><div>Progress</div><div style="text-align:right">Score</div>
        </div>
        <%
            String[] avColors = {"#ff2200","#0044ff","#00cc44","#cc00cc","#ff9900","#00aacc","#ff4488","#44ff88"};
            for (int i = 0; i < rows.size(); i++) {
                String nm = rows.get(i)[0];
                int sc    = Integer.parseInt(rows.get(i)[1]);
                int pct   = topScore > 0 ? (int)(sc * 100.0 / topScore) : 0;
                String rowCls   = i==0?"tr1":i==1?"tr2":i==2?"tr3":"";
                String rkCls    = i==0?"rk1":i==1?"rk2":i==2?"rk3":"rkn";
                String rkLabel  = i==0?"🥇":i==1?"🥈":i==2?"🥉":"#"+(i+1);
                String svCls    = i==0?"sv1":i==1?"sv2":i==2?"sv3":"";
                String barCls   = i==0?"top-bar":"";
                String avc      = avColors[i % avColors.length];
                String avl      = nm.substring(0,1).toUpperCase();
        %>
        <div class="table-row <%= rowCls %>">
            <div class="rank-badge <%= rkCls %>"><%= rkLabel %></div>
            <div class="driver-cell">
                <div class="driver-avatar" style="background:<%= avc %>22;border:1px solid <%= avc %>66;color:<%= avc %>"><%= avl %></div>
                <span class="driver-name"><%= nm %></span>
            </div>
            <div class="progress-wrap">
                <div class="progress-bar-bg"><div class="progress-bar-fill <%= barCls %>" style="width:<%= pct %>%"></div></div>
            </div>
            <div class="score-val <%= svCls %>"><%= sc %></div>
        </div>
        <% } %>
    </div>
    <% } %>

    <div class="footer">
        <span class="footer-flags">🏁 🏁 🏁</span>
        Race Hard · Beat the Record · Become the Champion
    </div>
</div>
</body>
</html>
