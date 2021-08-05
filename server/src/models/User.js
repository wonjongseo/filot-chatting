import mongoose from "mongoose";
import bcrypt from "bcrypt";
import {config} from "../config";

const userSchema = new mongoose.Schema({
    id: {type: String, required: true, unique: true},
    password: {type: String, required: true},
    name: {type: String, required: true},
    nick_name: {type: String, default: "a", unique: true},
    phone_number: {type: String, default: "1234", unique: true},
    chats: [{type: mongoose.Schema.Types.ObjectId, ref: "Chat"}],
    // friends: [{type: mongoose.Schema.Types.ObjectId, ref: "User"}],
});
// userSchema.virtual('id').get(function(){
//     return this._id.toString()
// })
// userSchema.set('toJSON', {virtuals: true})
//userSchema.set('toOject', {virtuals: true})

// 회원가입하기 전 해쉬화
userSchema.pre("save", async function () {
    this.password = await bcrypt.hash(this.password, config.bcrypt.salt);
});

const User = mongoose.model("User", userSchema);

export default User;
