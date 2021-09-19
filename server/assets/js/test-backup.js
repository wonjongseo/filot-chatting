import SocketIO from "socket.io";
import {
    TESTcreateChat,
    createChattingRoom,
    importChatting,
} from "../../src/controller/chatController_backup";

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

    function countRoom(roomName) {
        return io.sockets.adapter.rooms.get(roomName)?.size;
    }
    io.on("connection", (socket) => {
        console.log("asdasdasdasdasdasdnjasd");
    });
    const chat = io.of("/chat");

    chat.on("connection", (socket) => {
        console.log(`connectioned`);
        socket.onAny((event) => console.log(`Socket Event: ${event}`));

        socket.on("enter_room", async (roomInfo, done) => {
            const {roomNum, ChatUser1, ChatUser2, createRoom} =
                await createChattingRoom(roomInfo);
            socket.join(roomNum);
            // socket["name"] = ChatUser1.name;
            var {chats} = await importChatting(createRoom);
            chats = JSON.stringify(chats);
            io.sockets.to(roomNum).emit("load-message", chats, socket["name"]);
            done();
            socket.to(roomNum).emit("del");
        });

        socket.on("disconnecting", () => {
            socket.emit("bye", "ㅠㅠ");
        });

        // socket.emit("enter_room" , { object user1,})

        socket.on("message", (messageInfo, done) => {
            TESTcreateChat(messageInfo);
            console.log(`messageInfo : ${messageInfo}`);
            socket.to(messageInfo.roomNum).emit("message", messageInfo);

            console.log(`asdasd :${countRoom(messageInfo.roomNum)}`);
            if (countRoom(messageInfo.roomNum) > 1) {
                done();
                socket.to(messageInfo).emit("del");
            }
        });

        socket.on("name", (name) => {
            socket["name"] = name;
        });
        socket.on("load-message", (data, name) => {
            console.log(data, name);
            data.map((item) => {
                console.log(item);
                if (item.user != name) {
                    myChat(item.message);
                } else {
                    youChat(item.message);
                }
            });
        });
    });
};
