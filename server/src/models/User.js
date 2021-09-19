<<<<<<< HEAD
// OK

import mongoose from "mongoose";
=======
import mongoose from "mongoose";
import bcrypt from "bcrypt";
import {config} from "../config";
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87

const userSchema = new mongoose.Schema({
    id: {type: String, required: true, unique: true},
    password: {type: String, required: true},
    name: {type: String, required: true},
<<<<<<< HEAD
    phone_number: {type: String, default: "null"},
    rooms: [{type: mongoose.Schema.Types.ObjectId, ref: "ChatsRoom"}],
    state: {type: Number, default: 0},
    role: {type: String, default: "null"},
    github: {type: String, default: "null"},
    email: {type: String, default: "null"},
=======
    nick_name: {type: String, required: true, unique: true},
    phone_number: {type: String, required: true, unique: true},
    //Number
});

// 회원가입하기 전 해쉬화
userSchema.pre("save", async function () {
    this.password = await bcrypt.hash(this.password, config.bcrypt.salt);
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87
});

const User = mongoose.model("User", userSchema);

export default User;
