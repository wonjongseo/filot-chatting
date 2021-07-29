import User from "../models/User";
import bcrypt from "bcrypt";

export const home = async (req, res, next) => {
    const users = await User.find({});

    res.render("home", {users});
};
export const getJoin = (req, res, next) => {
    res.render("join");
};

export const postJoin = async (req, res, next) => {
    const {id, password, confirmPassword, nickName, introduction} = req.body;
    if (password !== confirmPassword) {
        res.status(400).render("join", {errorMessage: "Password do not match"});
    }
    const existUser = await User.exists({$or: [{id}, {nickName}]});
    if (existUser) {
        res.status(400).render("join", {
            errorMessage: "existsUser or nickName is already taken",
        });
    }
    try {
        await User.create({
            id,
            nickName,
            password,
            introduction,
        });
        return res.redirect("/login");
    } catch (error) {
        console.error(error);
        res.render("join", {errorMessage: error._message});
    }
};

export const getFind = async (req, res, next) => {
    const {nickName} = req.query;

    const user = await User.findOne({nickName});

    res.render("profile", {user});
};

export const getLogin = (req, res, next) => {
    res.render("login");
};

export const postLogin = async (req, res, next) => {
    const {id, password} = req.body;
    const user = await User.findOne({id});
    if (!user) {
        res.render("join", {errorMessage: "없는 아이디입니다."});
    }
    const comfirmed = await bcrypt.compare(password, user.password);

    if (!comfirmed) {
        return res.render("login", {errorMessage: "비밀번호가 틀려요"});
    }

    res.redirect("/");
};
