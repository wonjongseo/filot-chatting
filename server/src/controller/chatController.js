import Chat from "../models/Chat";
import ChatsRoom from "../models/ChatingRoom";
import User from "../models/User";

// 단톡방
export const addUser = async (data) => {
    const {roomNum, user: name} = data;

    const room = await ChatsRoom.findOne({roomNum});

    if (!room) {
        console.log(`${roomNum} room Not found `);
        return;
    }

    const user = await User.findOne({name}).select("_id rooms");

    if (!user) {
        console.log(`${name} User Not found `);
        return;
    }

    const user_string = JSON.stringify(user._id);
    const ok = room?.user?.find((userId) => {
        const a = JSON.stringify(userId);

        return a === user_string;
    });
    if (ok) {
        console.log(`${name} is already in room`);
        return;
    }
    room.user.push(user);
    await room.save();
    user.rooms.push(room._id);
    await user.save();
};

export const createChattingRoom = async (data) => {
    const {userList, roomNum} = data;
    let createRoom = await ChatsRoom.findOne({roomNum});
    if (createRoom) {
        return {
            createRoom,
            roomNum,
        };
    }
    createRoom = await ChatsRoom.create({roomNum});
    userList.map(async (name, index) => {
        const user = await User.findOne({name});
        if (!user) {
            console.log("not found user");
            return;
        }
        user.rooms.push(createRoom._id);
        createRoom.user.push(user._id);
        user.save();

        if (index === userList.length - 1) {
            await createRoom.save();
        }
    });

    if (createRoom) {
        return {
            createRoom,
            roomNum,
        };
    }
};
export const importChatting = async (createRoom) => {
    console.log(`createRoom : ${createRoom}`);
    return ChatsRoom.findOne({roomNum: createRoom.roomNum})
        .select("-_id")
        .populate({
            path: "chats",
            select: "-_id -chatRoom",
        });
};

export const parsingChats = (chat) => {
    const user = chat.username;
    const message = chat.message;
    const dataObj = {message, user};
    const data = JSON.stringify(dataObj, data);
    return data;
};

export const createChat = async (data) => {
    const objData = JSON.parse(data);

    const {user, message, roomNum} = objData;
    const room = await ChatsRoom.findOne({roomNum});
    console.log(room);
    const dbChat = await Chat.create({
        chatRoom: room._id,
        message,
        user,
    });
    console.log(dbChat);
    room.chats.push(dbChat._id);
    room.save();
};

export const getChatsRommList = async (req, res, next) => {
    const {id} = req;
    const roomList1 = await User.findOne({id})
        .select("name -_id")
        .populate({
            path: "rooms",
            select: "roomNum -_id createdAt",
            populate: {
                path: "user",
                select: "-password -_id",
            },
        });
    console.log(roomList);
    const roomList = await ChatsRoom.find({}).select("-_id").populate({
        path: "user",
        select: "-id -password -rooms",
    });

    return res.json(roomList);
};
