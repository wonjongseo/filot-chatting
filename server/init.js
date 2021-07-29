import express from "express";
import path from "path";
import morgan from "morgan";
import globalRouter from "./router/globalRouter";

const PORT = 4000;

const app = express();

app.use(morgan("dev"));

// pug
app.set("view engine", "pug");
app.set("views", path.join(__dirname, "views"));

app.use("/", globalRouter);

const handleListen = () =>
    console.log(`Server is Listening on http://localhost:${PORT}`);

app.listen(PORT, handleListen);
