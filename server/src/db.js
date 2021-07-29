import mongoose from "mongoose";

mongoose.connect("mongodb://127.0.0.1:27017/filot", {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    createIndexes: true,
});

const db = mongoose.connection;

const handleOpen = () => console.log("connected to DB");
const handleError = (error) => console.log("DB ERROR", error);

db.on("error", handleError);
db.once("open", handleOpen);