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

    // 처음 유저 둘이 할당받은 roomNum를 유저 정보 안에 넣음
    chat.on("create-room", async (data) => {
        const objData = JSON.parse(data);
        const {user1, user2, roomNum} = objData;

        const chattingUser1 = await User.find({id: user1});
        chattingUser1.roomNum = roomNum;
        const chattingUser2 = await User.find({id: user2});
        chattingUser2.roomNum = roomNum;
    });
    chat.on("enter-roomNum", (data) => {
        // 방 만드는 것과
        // 방에 들어가는 것을 나눠야함
        // 왜나면 enter-room 하면 방에 들어갈때마다
        // db 에 들어가서 유저를 찾고 유저.roomNum을 갱신 할 꺼임
        // 그러므로 create-room 이벤트와 enter-room 을 나눠 생각해야함
        //  문제 2
        // 방에 들어오고 난 후에 user1 과 user2의 채팅을 어떻게 구별할 것이냐

        const user1_chat = await Chat.find({id: user1, roomNum});
        const user2_chat = await Chat.find({id: user2, roomNum});
        user1_chat.map(async (chat) => {
            const user = chat.username;
            const message = chat.message;
            const dataObj = {message, user};
            const data = JSON.stringify(dataObj, data);

            socket.emit("message", data);
        });
        user2_chat.map(async (chat) => {
            const user = chat.username;
            const message = chat.message;
            const dataObj = {message, user};
            const data = JSON.stringify(dataObj, data);

            socket.emit("message", data);
        });
    });

    socket.on("message", async (data) => {
        // console.log(existChat);
        chat.to().emit("message", data);
        console.log(data);
        const dataObj = JSON.parse(data);
        const {message, user} = dataObj;

        const dbChat = await Chat.create({
            message,
            username: user,
        });
        // console.log(dbChat);
        // console.log(message, user);
    });
    io.on("connection", (socket) => {
        const headers = socket.handshake["headers"];
        console.log(headers);

        console.log("connection default namespace");
        socket.on("message", (data) => {
            console.log(`data from default => ${data}`);
            socket.emit("fromServer", "ok");
        });
    });
});
// 고유식별번호,
