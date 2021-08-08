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
import chatting from "../connection/chatting";
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

chatting(server);
