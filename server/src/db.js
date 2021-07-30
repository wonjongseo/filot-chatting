import mongoose from "mongoose";
import {config} from "./config";

// mongodb 연결
mongoose.connect(config.database.url, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    createIndexes: true,
    useFindAndModify: false,
});

const db = mongoose.connection;

const handleOpen = () => console.log("connected to DB");
const handleError = (error) => console.log("DB ERROR", error);

db.on("error", handleError);
db.once("open", handleOpen);
