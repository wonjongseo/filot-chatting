import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
    id: {type: String, required: true, unique: true},
    password: {type: String, required: true},
    name: {type: String, required: true},
    phone_number: {type: String, default: ""},
    rooms: [{type: mongoose.Schema.Types.ObjectId, ref: "ChatsRoom"}],
    state: {type: String, default: Date.now()},
    role: {type: String, default: ""},
    github: {type: String, default: ""},
    email: {type: String, default: ""},
});

// 회원가입하기 전 해쉬화

const User = mongoose.model("User", userSchema);

export default User;
