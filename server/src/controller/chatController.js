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

// 서버쪽에서 유저와 방 정보에 대해 받음
export const createChattingRoom = async (data) => {
    // json파일 java object로 변경
    const objData = JSON.parse(data);
    const {user1, user2, roomNum} = objData;
    // 데이터 베이스에서 이미 있는 방인지 확인
    let createRoom = await ChatsRoom.findOne({roomNum});

    const ChatUser1 = await User.findOne({name: user1});
    const ChatUser2 = await User.findOne({name: user2});

    if (createRoom) {
        return {roomNum, ChatUser1, ChatUser2, createRoom};
    }

    // 새로 만들어진 방이라면, 방과 유저 결합
    createRoom = await ChatsRoom.create({roomNum, user: ChatUser1._id});

    createRoom.user.push(ChatUser2._id);
    createRoom.save();

    ChatUser1.rooms.push(createRoom._id);
    ChatUser2.rooms.push(createRoom._id);
    ChatUser1.save();
    ChatUser2.save();

    return {roomNum, ChatUser1, ChatUser2, createRoom};
};
export const importChatting = async (createRoom) => {
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

// filot sever
// export const createChat = async (data, createRoom) => {
//     // 프론트에서 받은 채팅 java object로 풀기
//     const dataObj = JSON.parse(data);
//     const {message, user} = dataObj;

//     // 채팅 데베에 저장
//     const dbChat = await Chat.create({
//         chatRoom: createRoom._id,
//         message,
//         username: user,
//     });
//     createRoom.chats.push(dbChat._id);
//     createRoom.save();
// };

export const TESTcreateChat = async (data) => {
    console.log(data);
    const {name: user, message, roomNum} = data;
    const room = await ChatsRoom.findOne({roomNum});

    // // 채팅 데베에 저장
    const dbChat = await Chat.create({
        chatRoom: room._id,
        message,
        user,
    });
    room.chats.push(dbChat._id);
    room.save();
};

export const getChatsRommList = async (req, res, next) => {
    const roomList = await ChatsRoom.find({}).select("-_id").populate({
        path: "user",
        select: "-id -password -rooms",
    });

    return res.json(roomList);
};
