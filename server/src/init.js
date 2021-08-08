import "./db";
import "./models/User";
import "express-async-errors";
import helmet from "helmet";
import express from "express";
import http from "http";
import cors from "cors";
import morgan from "morgan";
import globalRouter from "./router/globalRouter";
import userRouter from "./router/userRouter";
import {config} from "./config";
import {auth, putEdit} from "./controller/userController";
import {isAuth} from "./middleware/auth";
import Chat from "./models/Chat";

import chatRouter from "./router/chatRouter";

import {Server} from "socket.io";
import User from "./models/User";
import {emit} from "process";
import ChatsRoom from "./models/ChatingRoom";
import mongoose, {isValidObjectId} from "mongoose";
const app = express();
const httpServer = http.createServer(app);
app.use(express.json());
app.use(helmet());
app.use(cors());
app.use(morgan("dev"));
app.set("view engine", "pug");
app.set("views", process.cwd() + "/src/views");
//라우터

app.use("/", globalRouter);
app.use("/users", userRouter);
app.use("/chats", chatRouter);
app.use("/auth", isAuth, auth);

app.use((req, res, next) => {
    res.status(404).send("NOT available");
});

//마지노선 에러 처리
app.use((error, req, res, next) => {
    console.error(error);
    res.status(500).json({massage: "Sorry try later :("});
});
const server = app.listen(config.host.port, () => {
    console.log(`Server is Listening on http://localhost:${config.host.port}`);
});

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
    let roomNum;
    socket.on("enter-room", async (data) => {
        const objData = JSON.parse(data);
        const {user1, user2} = objData;
        roomNum = objData.roomNum;
        console.log("enter-room");
        let createRoom = await ChatsRoom.findOne({roomNum});
        const ChatUser1 = await User.findOne({id: user1});
        const ChatUser2 = await User.findOne({id: user2});
        if (!createRoom) {
            createRoom = await ChatsRoom.create({
                roomNum,
                user: ChatUser1._id,
            });
            createRoom.user.push(ChatUser2._id);
            createRoom.save();

            ChatUser1.rooms.push(createRoom._id);
            ChatUser2.rooms.push(createRoom._id);
            ChatUser1.save();
            ChatUser2.save();
        }
        socket.on("message", async (data) => {
            chat.emit("message", data);
            // 프론트 룸 설정 안해준듯?
            // socket.on(룸넘버) 해줘야하잖아
            const dataObj = JSON.parse(data);
            const {message, user} = dataObj;
            const dbChat = await Chat.create({
                chatRoom: createRoom._id,
                message,
                username: user,
            });
            createRoom.chats.push(dbChat._id);
            createRoom.save();
        });
        const user1_chat = await ChatsRoom.find({
            user: ChatUser1._id,
            roomNum: createRoom.roomNum,
        }).populate("chats");
        // const {chats} = user1_chat[0];
        // console.log(chats);
        if (user1_chat) {
            user1_chat[0].chats.map(async (chat) => {
                // console.log(chat);
                const user = chat.username;
                const message = chat.message;
                console.log(`this is username ! ${user}`);
                console.log(`this is message ! ${message}`);
                const dataObj = {message, user};
                const data = JSON.stringify(dataObj, data);

                socket.emit("message", data);
            });
        }
        const user2_chat = await User.find({
            id: ChatUser2._id,
            roomNum: createRoom.roomNum,
        });
        if (user2_chat) {
            user2_chat.map(async (chat) => {
                const user = chat.username;
                const message = chat.message;
                const dataObj = {message, user};
                const data = JSON.stringify(dataObj, data);

                //    socket.emit("message", data);
            });
        }

        io.on("connection", (socket) => {
            const headers = socket.handshake["headers"];

            socket.on("message", (data) => {});
        });
    });

    // socket.on("enter-room", async (data) => {
    //     console.log("enter-romm");
    //     console.log(data);
    //     // 방 만드는 것과
    //     // 방에 들어가는 것을 나눠야함
    //     // 왜나면 enter-room 하면 방에 들어갈때마다
    //     // db 에 들어가서 유저를 찾고 유저.roomNum을 갱신 할 꺼임
    //     // 그러므로 create-room 이벤트와 enter-room 을 나눠 생각해야함
    //     //  문제 2
    //     // 방에 들어오고 난 후에 user1 과 user2의 채팅을 어떻게 구별할 것이냐

    //     const user1_chat = await Chat.find({id: user1, roomNum});
    //     const user2_chat = await Chat.find({id: user2, roomNum});
    //     user1_chat.map(async (chat) => {
    //         const user = chat.username;
    //         const message = chat.message;
    //         const dataObj = {message, user};
    //         const data = JSON.stringify(dataObj, data);

    //         socket.emit("message", data);
    //     });
    //     user2_chat.map(async (chat) => {
    //         const user = chat.username;
    //         const message = chat.message;
    //         const dataObj = {message, user};
    //         const data = JSON.stringify(dataObj, data);

    //         socket.emit("message", data);
    //     });
    // });
});
// 고유식별번호,
