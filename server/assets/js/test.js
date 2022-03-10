import SocketIO from "socket.io";
import ChatsRoom from "../../src/models/ChatingRoom";
import User from "../../src/models/User";
import {addUser} from "../../src/controller/chatController";
import {
    createChat,
    createChattingRoom,
    importChatting,
} from "../../src/controller/chatController";

export const pugTest = (server) => {
    const io = SocketIO(server, {
        cors: {
            origin: "*",
        },
        allowEIO3: true,
        requestCert: true,
        secure: true,
        rejectUnauthorized: false,
        transports: ["websocket"],
    });

    const chat = io.of("/");

    chat.on("connection", (socket) => {
        console.log(`connectioned`);
        socket.onAny((event) => console.log(`Socket Event: ${event}`));

        // socket.on("create-room")
        socket.on("enter_room", async (roomInfo) => {
            const objData = JSON.parse(roomInfo);
            const {createRoom, roomNum} = await createChattingRoom(objData);
            socket["roomNum"] = roomNum;
            socket.join(roomNum);

            var {chats} = await importChatting(createRoom);
            chats = JSON.stringify(chats);
            console.log(chats);

            io.sockets.to(roomNum).emit("load-message", chats);
        });

        socket.on("add_user", async (data) => {
            const user = JSON.parse(data);
            const {roomNum} = socket;
            await addUser({roomNum, user});
            socket.emit("success", "success");
        });

        socket.on("message", (messageInfo) => {
            createChat(messageInfo);
            const {roomNum} = socket;
            socket.to(roomNum).emit("message", messageInfo);
        });
    });
};
