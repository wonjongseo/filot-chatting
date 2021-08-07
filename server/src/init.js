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
// io.connect("http://localhost:3002");

chat.on("connection", (socket) => {
    const headers = socket.handshake["headers"];

    console.log(headers);
    console.log("connection /chat");

    socket.on("message", async (data) => {
        // console.log(`data from /chat => ${data}`);
        const existChat = Chat.find({});
        console.log(existChat[0].message);

        chat.emit("message", data);
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
