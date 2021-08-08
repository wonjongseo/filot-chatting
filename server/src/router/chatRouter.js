import express from "express";
import {
    postChatByUser,
    getChatByUser,
    findChatByUser,
    createChatRoom,
    seeAllChat,
} from "../controller/chatController";
import {isAuth} from "../middleware/auth";

export const chatRouter = express.Router();

chatRouter.route("/").all(isAuth).get(getChatByUser).post(postChatByUser);
chatRouter.get("/all", seeAllChat);

chatRouter.get("/:id", isAuth, findChatByUser);

export default chatRouter;
