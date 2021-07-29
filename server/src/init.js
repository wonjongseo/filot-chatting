import "./db";
import "./models/User";
import express from "express";
import path from "path";
import morgan from "morgan";
import globalRouter from "./router/globalRouter";
import userRouter from "./router/userRouter";

const PORT = 7777;

const app = express();

app.use(morgan("dev"));
app.use(express.urlencoded({extended: true}));

// pug
app.set("view engine", "pug");
app.set("views", path.join(__dirname, "views"));
app.use("/", globalRouter);
app.use("/user", userRouter);

const handleListen = () =>
    console.log(`Server is Listening on http://localhost:${PORT}`);

app.listen(PORT, handleListen);
