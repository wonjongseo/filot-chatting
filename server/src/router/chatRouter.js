import express from "express";
import {getChatsRommList} from "../controller/chatController";
import {isAuth} from "../middleware/auth";

const chatRouter = express.Router();

chatRouter.get("/", (req, res, next) => {
    res.render("chat");
});
chatRouter.get("/rooms", isAuth, getChatsRommList);

chatRouter.get("/a", (req, res, next) => {
    const {userList} = req.body;

    userList.map(({name}) => console.log(name));
    return res.end;
});

export default chatRouter;
