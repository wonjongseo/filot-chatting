import mongoose from "mongoose";
import bcrypt from "bcrypt";
import {config} from "../config";

const userSchema = new mongoose.Schema({
    id: {type: String, required: true, unique: true},
    password: {type: String, required: true},
    name: {type: String, required: true},
    nick_name: {type: String, unique: true},
    phone_number: {type: String, default: "1234", unique: true},
    //Todo multi room
    rooms: [{type: mongoose.Schema.Types.ObjectId, ref: "ChatsRoom"}],
});

// 회원가입하기 전 해쉬화

const User = mongoose.model("User", userSchema);

export default User;
