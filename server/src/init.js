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
import {initSocket} from "../connection/socket";
import chatRouter from "./router/chatRouter";
// import {Server} from "socket.io";
var socketio = require("socket.io");
const app = express();

app.use(express.json());
app.use(helmet());
app.use(cors());
app.use(morgan("dev"));
app.set("view engine", "pug");
app.set("views", process.cwd() + "/src/views");
//라우터
app.get("/abc", (req, res) => {
    return res.render("chat");
});
app.get("/def", (req, res) => {
    return res.sendFile(__dirname + "/index.html");
});

app.use("/", function (req, res, next) {
    res.sendFile(__dirname + "/filot.html");
});
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

const server = http.createServer(app);
server.listen(config.host.port, () => {
    console.log(`Server is Listening on http://localhost:${config.host.port}`);
});

const io = socketio(server);

io.sockets.on("connection", function (socket) {
    console.log("id");
    // receives message from DB
    Chat.find(function (err, result) {
        for (var i = 0; i < result.length; i++) {
            var dbData = {
                name: result[i].username,
                message: result[i].text,
            };
            io.emit("preload", dbData);
        }
    });

    // sends message to other users + stores data(username + message) into DB
    socket.on("message", function (data) {
        io.sockets.emit("message", data);
        // add chat into the model
        var chat = new Chat({username: data.name, text: data.message});

        chat.save(function (err, data) {
            if (err) {
                // TODO handle the error
                console.log("error");
            }
            console.log("message is inserted");
        });
    });
});
