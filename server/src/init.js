import "./db";
import "./models/User";
import "express-async-errors";
import express from "express";
import path from "path";
import morgan from "morgan";
import globalRouter from "./router/globalRouter";
import userRouter from "./router/userRouter";

const PORT = 9999;

const app = express();

// log 보는거 도와주는 라이브러리
app.use(morgan("dev"));

// html에서 body 받아오는거 가능하게 해줌
app.use(express.urlencoded({extended: true}));
app.use(express.json());

// pug
app.set("view engine", "pug");
app.set("views", path.join(__dirname, "views"));

//라우터
app.use("/", globalRouter);
app.use("/user", userRouter);

app.use((req, res, next) => {
    res.status(404).send("NOT available");
});

//마지노선 에러 처리
app.use((error, req, res, next) => {
    console.error(error);
    res.status(500).send("Sorry Try later");
});

const handleListen = () =>
    console.log(`Server is Listening on http://localhost:${PORT}`);

//서버 구동
app.listen(PORT, handleListen);
