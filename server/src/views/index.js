const chat = document.getElementById("chat");
const user = document.getElementById("user");
const button = document.getElementById("button");
import {io} from "socket.io-client";

const socket = io();

socket.emit("joinRoom", {roomName: "myroom"});

socket.on("recMsg", (data) => {
    console.log(data.comment);
});

const onClick = (e) => {
    e.preventDefault();
    socket.emit("reqMsg", {comment: user.innerText});
};

button.addEventListener("submit", onClick);
