import SocketIO from "socket.io";
import {addUser} from "../../src/controller/chatController";
import {
    TESTcreateChat,
    createChattingRoom,
    importChatting,
} from "../../src/controller/chatController";

export const pugTest = (server) => {
    const io = SocketIO(server, {
        cors: {
            origin: "*",
        },
        // allowEIO3: true,
        // requestCert: true,
        // secure: true,
        // rejectUnauthorized: false,
        // transports: ["websocket"],
    });

    function countRoom(roomName) {
        return io.sockets.adapter.rooms.get(roomName)?.size;
    }

    const chat = io.of("/chat");

    chat.on("connection", (socket) => {
        console.log(`connectioned`);
        socket.onAny((event) => console.log(`Socket Event: ${event}`));

        socket.on("enter_room", async (roomInfo, done) => {
            const {roomNum, createRoom} = await createChattingRoom(roomInfo);
            socket["roomNum"] = roomNum;
            socket.join(roomNum);
            var {chats} = await importChatting(createRoom);
            chats = JSON.stringify(chats);
            io.sockets.to(roomNum).emit("load-message", chats);
            done();
            socket.to(roomNum).emit("del");
        });

        socket.on("add_user", async (data) => {
            const user = JSON.parse(data);
            const {roomNum} = socket;
            await addUser({roomNum, user});
            socket.emit("success", "success");
        });

        socket.on("message", (messageInfo, done) => {
            TESTcreateChat(messageInfo);
            socket.to(messageInfo.roomNum).emit("message", messageInfo);
        });

        socket.on("name", (name) => {
            socket["name"] = name;
        });
        socket.on("success", (data) => {
            console.log(data);
        });
        // socket.on("load-message", (data, name) => {
        //     console.log(data, name);
        //     data.map((item) => {
        //         console.log(item);
        //         if (item.user != name) {
        //             myChat(item.message);
        //         } else {
        //             youChat(item.message);
        //         }
        //     });
        // });
    });
};
