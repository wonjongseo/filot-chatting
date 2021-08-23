import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
    id: {type: String, required: true, unique: true},
    password: {type: String, required: true},
    name: {type: String, required: true},
    phone_number: {type: String, default: "null"},
    rooms: [{type: mongoose.Schema.Types.ObjectId, ref: "ChatsRoom"}],
    state: {type: Number, default: 0},
    role: {type: String, default: "null"},
    github: {type: String, default: "null"},
    email: {type: String, default: "null"},
});

// 회원가입하기 전 해쉬화

const User = mongoose.model("User", userSchema);

export default User;
