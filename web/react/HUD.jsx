import React from "react";

function HUD(props){

return(

<div style={{
position:"absolute",
top:"10px",
left:"10px",
color:"white",
fontSize:"20px"
}}>

<div>Score: {props.score}</div>

<div>Speed: {props.speed}</div>

</div>

);

}

export default HUD;