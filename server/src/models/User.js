import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
    id: {type: String, required: true, unique: true},
    password: {type: String, required: true},
    nickName: {type: String, required: true, unique: true},
    introduction: {type: String, default: "Hello"},

    //Number
});

const User = mongoose.model("User", userSchema);

export default User;
