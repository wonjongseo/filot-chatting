const socket = io("http://localhost:3000/chat");
const welcome = document.getElementById("welcome");
const initForm = welcome.querySelector("form");
const room = document.getElementById("room");
const chat = document.getElementById("chat");
const user1 = welcome.querySelector("#user1");
const user2 = welcome.querySelector("#user2");
const loadingBtn = room.querySelector("#loading_btn");

const USER1_CHAT = "user1_chat";
const USER2_CHAT = "user2_chat";
const YOUER_MEESAGE = "your_message";

let objData;
let name = "";
room.hidden = true;
let existingData;
let readMe;

const myChat = (msg) => {
    const msgContainer = document.createElement("div");
    const msgSpan = document.createElement("span");
    readMe = document.createElement("span");
    readMe.innerHTML = 1;
    readMe.classList = "readMe";
    msgSpan.classList.add("my_message");
    msgSpan.innerHTML = msg;
    msgContainer.classList.add("my_name");
    msgContainer.classList.add(USER2_CHAT);
    msgContainer.appendChild(readMe);
    msgContainer.append(msgSpan);
    chat.appendChild(msgContainer);
};

const youChat = (msg) => {
    const Container = document.createElement("div");
    const avatar = document.createElement("img");
    avatar.src = "/static/js/anon.png";
    const div = document.createElement("div");
    const userContainer = document.createElement("div");
    const msgContainer = document.createElement("div");
    const msgSpan = document.createElement("span");
    const userSpan = document.createElement("span");

    msgSpan.innerHTML = msg;
    userSpan.innerHTML = user2.value;

    msgSpan.classList.add(YOUER_MEESAGE);
    userContainer.classList.add("your_name");

    msgContainer.appendChild(msgSpan);
    userContainer.appendChild(userSpan);

    avatar.classList.add("avatar");
    Container.classList.add("container");
    div.append(userContainer);
    div.append(msgContainer);
    div.classList.add(USER1_CHAT);
    Container.append(avatar);
    Container.append(div);
    chat.appendChild(Container);
};

const showRoom = () => {
    room.hidden = false;
    welcome.hidden = true;
    const msgForm = room.querySelector("#msg");
    msgForm.addEventListener("submit", handleMsgForm);
};

const del = () => {
    const readMes = document.querySelectorAll(".readMe");
    readMes.forEach((item) => {
        item.remove();
    });
};

socket.on("del", () => {
    del();
});

const handleMsgForm = async (event) => {
    event.preventDefault();
    const input = document.querySelector("#msg input");
    const messageData = {
        name,
        message: input.value,
        roomNum: objData.roomNum,
    };

    socket.emit("message", messageData, del);
    myChat(messageData.message);
    input.value = "";
};

const handleNameForm = (event) => {
    event.preventDefault();
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
    name = user2.value;
    headerUsername.innerHTML = name;

    objData = {
        roomNum: roomNameInput.value,
        user1: user1Input.value,
        user2: user2Input.value,
    };

    const roomInfo = await JSON.stringify(objData);

    socket.emit("enter_room", roomInfo, showRoom);

    if (existingData !== undefined) {
        console.log(existingData);
        existingData.map((item) => {
            if (item.user != name) {
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

socket.once("load-message", (data, name) => {
    existingData = data;
    data.map((item) => {
        if (item.user != name) {
            myChat(item.message);
        } else {
            youChat(item.message);
        }
    });
});
