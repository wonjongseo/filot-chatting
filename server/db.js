import mongoose from "mongoose";

mongoose.connect("#", {
    useNewUrlParser: true,
    useUnifiedTopology: true,
});

const db = mongoose.connection;

const handleOpen = () => console.log("connected to DB");
const handleError = (error) => console.log("DB ERROR", error);

db.on("error", handleError);
db.once("open", handleOpen);
