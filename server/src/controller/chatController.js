import Chat from "../models/Chat";
import ChatsRoom from "../models/ChatingRoom";
import User from "../models/User";

// 서버쪽에서 유저와 방 정보에 대해 받음
export const createChattingRoom = async (data) => {

    // json파일 java object로 변경
    const objData = JSON.parse(data);
    const {user1, user2, roomNum} = objData;

    // 데이터 베이스에서 이미 있는 방인지 확인
    let createRoom = await ChatsRoom.findOne({roomNum});
    
    const ChatUser1 = await User.findOne({id: user1});
    const ChatUser2 = await User.findOne({id: user2});

    if (createRoom) {
        return {roomNum,ChatUser1,ChatUser2,createRoom,}
    };

    // 새로 만들어진 방이라면, 방과 유저 결합
        createRoom = await ChatsRoom.create({roomNum,user: ChatUser1._id, });
        
        createRoom.user.push(ChatUser2._id);
        createRoom.save();

        ChatUser1.rooms.push(createRoom._id);
        ChatUser2.rooms.push(createRoom._id);
        ChatUser1.save();
        ChatUser2.save();
    }
    return {roomNum, ChatUser1, ChatUser2, createRoom};
};
export const importChatting = async (createRoom) => {
    return ChatsRoom.findOne({roomNum: createRoom}).populate("chats");
};

export const parsingChats = (chat) => {
    const user = chat.username;
    const message = chat.message;
    const dataObj = {message, user};
    const data = JSON.stringify(dataObj, data);
    return data;
};

export const createChat = async (data, createRoom) => {
    // 프론트에서 받은 채팅 java object로 풀기
    const dataObj = JSON.parse(data);
    const {message, user} = dataObj;
    
    // 채팅 데베에 저장
    const dbChat = await Chat.create({
        chatRoom: createRoom._id,
        message,
        username: user,
    });
    createRoom.chats.push(dbChat._id);
    createRoom.save();
};
