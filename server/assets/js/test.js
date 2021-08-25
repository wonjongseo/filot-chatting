import SocketIO from "socket.io";
import {
    TESTcreateChat,
    createChattingRoom,
    importChatting,
} from "../../src/controller/chatController";

export const pugTest = (server) => {
    const io = SocketIO(server);
    function publicRooms() {
        const {
            sockets: {
                adapter: {sids, rooms},
            },
        } = io;
        const publicRooms = [];
        rooms.forEach((_, key) => {
            if (sids.get(key) === undefined) {
                publicRooms.push(key);
            }
        });
        return publicRooms;
    }
    function countRoom(roomName) {
        return io.sockets.adapter.rooms.get(roomName)?.size;
    }
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
            socket.to(roomNum).emit("del");
        });

        socket.on("disconnecting", () => {
            socket.emit("bye", "ㅠㅠ");
        });

        socket.on("message", (messageInfo, done) => {
            TESTcreateChat(messageInfo);
            console.log(messageInfo.roomNum);
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
