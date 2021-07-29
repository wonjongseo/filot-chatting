import mongoose from "mongoose";

//데이터 형식을 지정해준다.
const chatSchema = new mongoose.Schema({
    context: {type: String, required: true},
    sendTime: {type: Date, default: Date.now},
    // 읽음, 안읽음
    // check : {type: Boolean, default: false}
});

//모델을 만들어준다.
const Chat = mongoose.model("Chat", chatSchema);

export default Chat;
