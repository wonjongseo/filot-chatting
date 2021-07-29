import mongoose from "mongoose";
import bcrypt from "bcrypt";

const SORT = 5;

const userSchema = new mongoose.Schema({
    id: {type: String, required: true, unique: true},
    password: {type: String, required: true},
    nickName: {type: String, required: true, unique: true},
    introduction: {type: String, default: "Hello"},

    //Number
});

userSchema.pre("save", async function () {
    this.password = await bcrypt.hash(this.password, SORT);
});

const User = mongoose.model("User", userSchema);

export default User;
