import mongoose from "mongoose";

const chatsRoomSchema = new mongoose.Schema(
    {
        roomNum: String,
        user: [
            {type: mongoose.Schema.Types.ObjectId, required: true, ref: "User"},
        ],
        chats: [
            {type: mongoose.Schema.Types.ObjectId, required: true, ref: "Chat"},
        ],
    },
    {
        timestamps: true,
    }
);

const ChatsRoom = mongoose.model("ChatsRoom", chatsRoomSchema);

export default ChatsRoom;
