import {Server} from "socket.io";
import {
    createChat,
    createChattingRoom,
    parsingChats,
    importChatting,
} from "../src/controller/chatController";

const chatting = (server) => {
    const io = new Server(server, {
        cors: {
            origin: "*",
        },
        allowEIO3: true,

        requestCert: true,
        secure: true,
        rejectUnauthorized: false,
        transports: ["websocket"],
    });
    io.on("message", (data) => {
        console.log(data);
    });
    const chat = io.of("/chat");

    chat.on("connection", async (socket) => {
        const headers = socket.handshake["headers"];
        socket.on("enter-room", async (data) => {
            const {roomNum, ChatUser1, ChatUser2, createRoom} =
                await createChattingRoom(data);

            socket.on("message", async (data) => {
                chat.emit("message", data);
                createChat(data, createRoom);
            });
            const chatsInRoom = await importChatting(roomNum);
            // ################### test
            console.log(chatsInRoom);
            const user = chatsInRoom.chats[0].username;
            const message = chatsInRoom.chats[0].message;
            const dataObj = {message, user};
            const data1 = JSON.stringify(dataObj, data1);
            socket.emit("message", data1);
        });
    });
};

export default chatting;
