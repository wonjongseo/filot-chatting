import {Server} from "socket.io";
import jwt from "jsonwebtoken";
import {config} from "../src/config";
import axios from "axios";
const initSockett = (server) => {
    const io = new Server(server);

    const chat = io.of("chat");

    chat.on("connection", (socket) => {
        console.log("chat 네임스페이스에 접속");
        const req = socket.request;
        // req에서 referer 빼낸 후 roomId로 정의
        const {
            headers: {referer},
        } = req;
        const roomId = referer
            .split("/")
            [referer.split("/").length - 1].replace(/\?.+/, "");
        socket.join(roomId);
        socket.to(roomId).emit("join", {
            user: "system",
            chat: `${req.session.color}님이 입장하셨습니다.`,
        });
        socket.on("disconnect", () => {
            console.log("chat 네임스페이스 접속 해제");
            // socket.leave(방 아이디) leav는 socket.IO에서 만들어준 메소드임.
            socket.leave(roomId);

            const currentRoom = socket.adapter.rooms[roomId];
            const userCount = currentRoom ? currentRoom.length : 0;
            if (userCount === 0) {
                axios
                    .delete(`http://localhost:8005/room/${roomId}`)
                    .then(() => {
                        console.log("방 제거 요청 성공");
                    })
                    .catch((error) => {
                        console.error(error);
                    });
            } else {
                socket.to(roomId).emit("exit", {
                    user: "system",
                    chat: `${req.session.color}님이 퇴장하셨습니다.`,
                });
            }
        });
    });
};

export default initSockett;
