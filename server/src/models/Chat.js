// ㅇㅋ
import mongoose from "mongoose";

//데이터 형식을 지정해준다.
const chatSchema = new mongoose.Schema(
    {
        message: {type: String, required: true},
        chatRoom: {
            type: mongoose.Schema.Types.ObjectId,
            required: true,
            ref: "ChatsRoom",
        },
        user: {type: String, required: true},
    },
    {timestamps: true}
);

//모델을 만들어준다.
const Chat = mongoose.model("Chat", chatSchema);

export default Chat;
