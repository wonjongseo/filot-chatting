import mongoose from "mongoose";
import bcrypt from "bcrypt";
import {config} from "../config";

const userSchema = new mongoose.Schema({
    id: {type: String, required: true, unique: true},
    password: {type: String, required: true},
    name: {type: String, required: true},
    nick_name: {type: String, required: true, unique: true},
    phone_number: {type: String, required: true, unique: true},
    //Number
});

// 회원가입하기 전 해쉬화
userSchema.pre("save", async function () {
    this.password = await bcrypt.hash(this.password, config.bcrypt.salt);
});

const User = mongoose.model("User", userSchema);

export default User;
