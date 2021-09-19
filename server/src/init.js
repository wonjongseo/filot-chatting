import "./db";
import "./models/User";
import "express-async-errors";
import helmet from "helmet";
import express from "express";
<<<<<<< HEAD
import http from "http";

=======
import path from "path";
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87
import cors from "cors";
import morgan from "morgan";
import globalRouter from "./router/globalRouter";
import userRouter from "./router/userRouter";
import {config} from "./config";
<<<<<<< HEAD
import {auth} from "./controller/userController";
import {isAuth} from "./middleware/auth";
import chatting from "../connection/chatting";
import {pugTest} from "../assets/js/test";
import chatRouter from "./router/chatRouter";
=======
import {auth, putEdit} from "./controller/userController";
import {isAuth} from "./middleware/auth";
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87

const app = express();

app.use(express.json());
app.use(helmet());
app.use(cors());
app.use(morgan("dev"));
<<<<<<< HEAD
app.set("view engine", "pug");
app.set("views", process.cwd() + "/src/views");

//라우터
app.use("/static", express.static("assets"));

app.use("/", globalRouter);
app.use("/users", userRouter);
app.use("/chat", chatRouter);
=======

//라우터
app.use("/", globalRouter);
app.use("/user", userRouter);
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87
app.use("/auth", isAuth, auth);

app.use((req, res, next) => {
    res.status(404).send("NOT available");
});

//마지노선 에러 처리
app.use((error, req, res, next) => {
    console.error(error);
<<<<<<< HEAD
    res.status(500).json({massage: "Sorry try later"});
});

const httpServer = http.createServer(app);
pugTest(httpServer);

httpServer.listen(config.host.port, () => {
    console.log(`Server is Listening on http://localhost:${config.host.port}`);
});
=======
    res.status(500).json({massage: "Sorry try later :("});
});

const handleListen = () =>
    console.log(`Server is Listening on http://localhost:${config.host.port}`);

//서버 구동
app.listen(config.host.port, handleListen);
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87
