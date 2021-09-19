import SocketIO from "socket.io";

import {
    createChat,
    createChattingRoom,
    parsingChats,
    importChatting,
} from "../src/controller/chatController";

const chatting = (server) => {
    const io = SocketIO(server);

    const chat = io.of("/chat");

    // name spae "chat" 과 연결
    chat.on("connection", async (socket) => {
        // 서버 쪽에서 item 이벤트로 두 유저와 방 번호를 받음

        socket.on("enter-room", async (data) => {
            console.log("enter-room");
            const {roomNum, ChatUser1, ChatUser2, createRoom} =
                await createChattingRoom(data);

            const chatsInRoom = await importChatting(roomNum);
            // 과거 존재하는 방의 채팅들 불러와 서버쪽에 보내줌
            JSON.stringify(chatsInRoom);

            console.log(chatsInRoom);
            socket.emit("load-message", chatsInRoom);

            // 서버에서 메세지가 오면
            socket.on("message", async (data) => {
                chat.emit("message", data);
                // 데이터베이스에 채팅 저장
                createChat(data, createRoom);
            });
        });
    });
};

export default chatting;
