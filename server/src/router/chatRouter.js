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

// chatRouter.get("/a", async (req, res, next) => {
//     try {
//         const {userList, roomNum} = req.body;
//         let createRoom = await ChatsRoom.findOne({roomNum});
//         if (createRoom) {
//             return res.json({message: "existing roomNum"});
//         }
//         createRoom = await ChatsRoom.create({roomNum});
//         userList.map(async ({name}, index) => {
//             const user = await User.findOne({name});
//             user.rooms.push(createRoom._id);
//             createRoom.user.push(user._id);

//             await user.save();

//             if (index === userList.length - 1) {
//                 await createRoom.save();
//             }
//         });
//         return res.json({message: "success"});
//     } catch (error) {
//         return res.json({message: error});
//     }
// });

export default chatRouter;
