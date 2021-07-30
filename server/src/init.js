import "./db";
import "./models/User";
import "express-async-errors";
import helmet from "helmet";
import express from "express";
import path from "path";
import cors from "cors";
import morgan from "morgan";
import globalRouter from "./router/globalRouter";
import userRouter from "./router/userRouter";
import {config} from "./config";
import {auth, putEdit} from "./controller/userController";
import {isAuth} from "./middleware/auth";

const app = express();

app.use(express.json());
app.use(helmet());
app.use(cors());
app.use(morgan("dev"));

//라우터
app.use("/", globalRouter);
app.use("/user", userRouter);
app.use("/auth", isAuth, auth);

app.use((req, res, next) => {
    res.status(404).send("NOT available");
});

//마지노선 에러 처리
app.use((error, req, res, next) => {
    console.error(error);
    res.status(500).json({massage: "Sorry try later :("});
});

const handleListen = () =>
    console.log(`Server is Listening on http://localhost:${config.host.port}`);

//서버 구동
app.listen(config.host.port, handleListen);
