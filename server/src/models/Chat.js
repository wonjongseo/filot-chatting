import mongoose from "mongoose";

//데이터 형식을 지정해준다.
const chatSchema = new mongoose.Schema({
    context: {type: String, required: true},
    send_time: {type: Date, default: Date.now},
    check: {type: Boolean, default: false},
});

//모델을 만들어준다.
const Chat = mongoose.model("Chat", chatSchema);

export default Chat;
