import express from "express";
import {getChatsRommList} from "../controller/chatController";
import {isAuth} from "../middleware/auth";
import Chat from "../models/Chat";
import ChatsRoom from "../models/ChatingRoom";
import User from "../models/User";

const chatRouter = express.Router();

chatRouter.get("/", (req, res, next) => {
    res.render("chat");
});

chatRouter.get("/rooms", isAuth, getChatsRommList);

chatRouter.get("/all-chat", async (req, res, next) => {
    const allChat = await Chat.find({});

    return res.json(allChat);
});
chatRouter.get("/all-chatroom", async (req, res, next) => {
    const allChatroom = await ChatsRoom.find({});

    return res.json(allChatroom);
});

export default chatRouter;
