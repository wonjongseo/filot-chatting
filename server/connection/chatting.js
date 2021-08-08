import {Server} from "socket.io";
import {
    createChat,
    createChattingRoom,
    existingChat,
    findChattingRoom,
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
            const user1_chat = await findChattingRoom(ChatUser1, createRoom);
            if (user1_chat) {
                user1_chat[0].chats.map(async (chat) => {
                    // console.log(chat);
                    const data = existingChat(chat);

                    socket.emit("message", data);
                });
            }
            const user2_chat = await findChattingRoom(ChatUser2, createRoom);
            console.log(user2_chat);
            if (user2_chat) {
                user2_chat[0].chats.map(async (chat) => {
                    const data = existingChat(chat);

                    socket.emit("message", data);
                });
            }

            io.on("connection", (socket) => {
                const headers = socket.handshake["headers"];

                socket.on("message", (data) => {});
            });
        });
    });
};

export default chatting;
