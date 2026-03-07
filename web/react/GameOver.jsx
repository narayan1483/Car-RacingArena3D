import React from "react";

function GameOver(props){

return(

<div style={{
position:"absolute",
top:"40%",
left:"50%",
transform:"translate(-50%,-50%)",
textAlign:"center",
color:"white"
}}>

<h1>Game Over</h1>

<h2>Your Score: {props.score}</h2>

<button
onClick={props.restart}
style={{
padding:"12px 30px",
fontSize:"18px",
background:"orange",
border:"none",
borderRadius:"10px",
cursor:"pointer"
}}
>

Restart Game

</button>

</div>

);

}

export default GameOver;