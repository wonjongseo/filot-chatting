import SocketIO from "socket.io";
import {
    TESTcreateChat,
    createChattingRoom,
    importChatting,
} from "../../src/controller/chatController";

export const pugTest = (server) => {
    const io = SocketIO(server);

    const chat = io.of("");
    chat.on("connection", (socket) => {
        socket["nickname"] = "Anonymous";
        socket.onAny((event) => console.log(`Socket Event: ${event}`));

        socket.on("enter_room", async (roomInfo, done) => {
            const {roomNum, ChatUser1, ChatUser2, createRoom} =
                await createChattingRoom(roomInfo);
            socket.join(roomNum);
            socket["name"] = ChatUser1.name;
            const {chats} = await importChatting(createRoom);
            io.sockets.to(roomNum).emit("load-message", chats, socket["name"]);
            done();
        });

        socket.on("disconnecting", () => {
            socket.emit("bye", "ㅠㅠ");
        });

        socket.on("message", (messageInfo) => {
            TESTcreateChat(messageInfo);
            console.log(messageInfo.roomNum);
            socket.to(messageInfo.roomNum).emit("message", messageInfo);
        });

        socket.on("name", (name) => {
            socket["name"] = name;
        });
        socket.on("load-message", (data, name) => {
            console.log(data, name);
            data.map((item) => {
                console.log(item);
                if (item.user == name) {
                    myChat(item.message);
                } else {
                    youChat(item.message);
                }
            });
        });
    });
};
