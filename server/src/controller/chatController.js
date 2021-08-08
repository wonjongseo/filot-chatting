import Chat from "../models/Chat";
import ChatsRoom from "../models/ChatingRoom";
import User from "../models/User";

export const getChatByUser = (req, res, next) => {
    const chats = Chat.find({});

    return res.json(chats);
};

export const postChatByUser = async (req, res, next) => {
    const {message} = req.body;
    const user = req.user;

    if (!user) {
        return res.json({message: "로그인을 먼저 해주세요"});
    }
    const chat = await Chat.create({
        message,
        username: user.name,
    });
    return res.json(chat);
};

export const findChatByUser = (req, res, next) => {
    const {user} = req.user;
};

export const seeAllChat = async (req, res, next) => {
    const chats = await Chat.find({});

    return res.json(chats);
};

export const createChattingRoom = async (data) => {
    const objData = JSON.parse(data);
    const {user1, user2} = objData;
    const roomNum = objData.roomNum;
    let createRoom = await ChatsRoom.findOne({roomNum});
    const ChatUser1 = await User.findOne({id: user1});
    const ChatUser2 = await User.findOne({id: user2});
    if (!createRoom) {
        createRoom = await ChatsRoom.create({
            roomNum,
            user: ChatUser1._id,
        });
        createRoom.user.push(ChatUser2._id);
        createRoom.save();

        ChatUser1.rooms.push(createRoom._id);
        ChatUser2.rooms.push(createRoom._id);
        ChatUser1.save();
        ChatUser2.save();
    }
    return {roomNum, ChatUser1, ChatUser2, createRoom};
};
export const findChattingRoom = async (ChatUser, createRoom) => {
    return ChatsRoom.find({
        user: ChatUser._id,
        roomNum: createRoom.roomNum,
    }).populate("chats");
};

export const existingChat = (chat) => {
    const user = chat.username;
    const message = chat.message;
    const dataObj = {message, user};
    const data = JSON.stringify(dataObj, data);
    return data;
};

export const createChat = async (data, createRoom) => {
    const dataObj = JSON.parse(data);
    const {message, user} = dataObj;
    const dbChat = await Chat.create({
        chatRoom: createRoom._id,
        message,
        username: user,
    });
    createRoom.chats.push(dbChat._id);
    createRoom.save();
};
