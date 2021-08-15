import express from "express";
import {getChatsRommList} from "../controller/chatController";
import {isAuth} from "../middleware/auth";

const chatRouter = express.Router();

chatRouter.get("/rooms", isAuth, getChatsRommList);

export default chatRouter;
