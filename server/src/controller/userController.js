import User from "../models/User";

export const home = async (req, res, next) => {
    const users = await User.find({});
    console.log(users);
    res.render("home", {users});
};
export const getJoin = (req, res, next) => {
    res.render("join");
};

export const postJoin = async (req, res, next) => {
    const {id, password, confirmPassword, nickName, introduction} = req.body;
    try {
        await User.create({
            id,
            nickName,
            password,
            introduction,
        });
        return res.redirect("/");
    } catch (error) {
        console.error(error);
        res.render("join", {errorMessage: error._message});
    }
};
