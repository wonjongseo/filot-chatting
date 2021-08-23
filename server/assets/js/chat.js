const socket = io("/");

const welcome = document.getElementById("welcome");
const initForm = welcome.querySelector("form");
const room = document.getElementById("room");
const chat = document.getElementById("chat");
const user1 = welcome.querySelector("#user1");
const loadingBtn = room.querySelector("#loading_btn");

const USER1_CHAT = "user1_chat";
const USER2_CHAT = "user2_chat";

let objData;
let name = "";
room.hidden = true;
let existingData;

const myChat = (msg) => {
    const div = document.createElement("div");
    div.classList.add(USER1_CHAT);
    div.innerHTML = msg;
    chat.appendChild(div);
};

const youChat = (msg) => {
    const div = document.createElement("div");
    div.classList.add(USER2_CHAT);
    div.innerHTML = msg;
    chat.appendChild(div);
};

const showRoom = () => {
    const h3 = room.querySelector("h3");
    h3.innerText = `Room ${objData.roomNum}`;
    room.hidden = false;
    welcome.hidden = true;
    const msgForm = room.querySelector("#msg");
    const nameForm = room.querySelector("#name");
    nameForm.addEventListener("submit", handleNameForm);
    msgForm.addEventListener("submit", handleMsgForm);
};

const handleMsgForm = async (event) => {
    event.preventDefault();
    const input = document.querySelector("#msg input");
    const messageData = {
        name,
        message: input.value,
        roomNum: objData.roomNum,
    };
    socket.emit("message", messageData);
    myChat(messageData.message);
    input.value = "";
};

const handleNameForm = (event) => {
    event.preventDefault();
    // const input = room.querySelector("#name input");
    // name = input.value;
    const headerUsername = document.querySelector("#username");
    name = user.value;
    headerUsername.innerHTML = name;
    socket.emit("name", input.value);
};

initForm.addEventListener("submit", async () => {
    event.preventDefault();
    const roomNameInput = document.getElementById("roomName");
    const user1Input = document.getElementById("user1");
    const user2Input = document.getElementById("user2");
    const headerUsername = document.querySelector("#username");
    name = user1.value;
    headerUsername.innerHTML = name;

    objData = {
        roomNum: roomNameInput.value,
        user1: user1Input.value,
        user2: user2Input.value,
    };

    const jsonata = await JSON.stringify(objData);

    socket.emit("enter_room", jsonata, showRoom);

    if (existingData !== undefined) {
        console.log(existingData);
        existingData.map((item) => {
            console.log(item);
            if (item.user == name) {
                myChat(item.message);
            } else {
                youChat(item.message);
            }
        });
    }
});

socket.on("message", (loggedInName) => {
    youChat(loggedInName.message);
});
socket.on("bye", (data) => {
    console.log(`asdasdsd`);
    console.log(data);
});

socket.on("load-message", (data, name) => {
    existingData = data;
    data.map((item) => {
        console.log(item);
        if (item.user == name) {
            myChat(item.message);
        } else {
            youChat(item.message);
        }
    });
});
