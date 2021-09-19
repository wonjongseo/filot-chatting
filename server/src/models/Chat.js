<<<<<<< HEAD
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
=======
import mongoose from "mongoose";

//데이터 형식을 지정해준다.
const chatSchema = new mongoose.Schema({
    context: {type: String, required: true},
    send_time: {type: Date, default: Date.now},
    check: {type: Boolean, default: false},
});
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87

//모델을 만들어준다.
const Chat = mongoose.model("Chat", chatSchema);

export default Chat;
