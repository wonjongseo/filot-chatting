import express from "express";
import {getChatsRommList} from "../controller/chatController";
import {isAuth} from "../middleware/auth";

const chatRouter = express.Router();

chatRouter.get("/", (req, res, next) => {
    res.render("chat");
});
chatRouter.get("/rooms", isAuth, getChatsRommList);

export default chatRouter;
