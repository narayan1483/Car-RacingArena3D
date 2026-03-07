import React from "react";

function GameMenu(props){

return(

<div style={{
position:"absolute",
top:"40%",
left:"50%",
transform:"translate(-50%,-50%)",
textAlign:"center",
color:"white"
}}>

<h1>🏎️ Car Racing Arena</h1>

<button
onClick={props.startGame}
style={{
padding:"15px 40px",
fontSize:"20px",
background:"red",
color:"white",
border:"none",
borderRadius:"10px",
cursor:"pointer"
}}
>

Start Game

</button>

</div>

);

}

export default GameMenu;