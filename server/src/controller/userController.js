import User from "../models/User";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import {config} from "../config";
import {use} from "express/lib/router";

export const home = async (req, res) => {
    // db에서 모든 유저 가져옴
    const users = await User.find({});
    res.status(200).json(users);
};

export const postJoin = async (req, res) => {
    const {id, password, password2, name, nick_name, phone_number} = req.body;

    // 입력한 두 비밀번호가 다르면 사용자 에러
    if (password != password2) {
        return res.status(409).json({message: "비밀번호가 틀립니다."});
    }
    const existUser = await User.exists({$or: [{id}, {nick_name}]});
    // 이미 존재하는 id라면 사용자 에러
    if (existUser) {
        return res
            .status(409)
            .json({message: "아이디 혹은 닉넴이이 이미 사용중입니다."});
    }
    const newPassword = await bcrypt.hash(password, config.bcrypt.salt);
    try {
        // db안에 유저 생성
        const user = await User.create({
            id,
            password: newPassword,
            name,
            nick_name,
            phone_number,
        });

        const token = createJwt(user);

        return res.status(200).json(token);
    } catch (error) {
        console.error(error);
        // db에러 잡음
        res.json({message: error});
    }
};

export const postLogin = async (req, res, next) => {
    const {id, password} = req.body;

    const user = await User.findOne({id});
    // 없으면 사용자 에러
    if (!user) {
        return res.status(401).json({errorMessage: "없는 아이디입니다."});
    }
    // 비밀번호 확인
    const match = await bcrypt.compare(password, user.password);

    if (!match) {
        return res.status(401).json({errorMessage: "비밀번호가 틀려요."});
    }
    const token = createJwt(user);
    return res.json({message: "로그인 성공!", user, token});
};

export const changePassword = async (req, res, next) => {
    const {
        user: {user},
        body: {password, new_password, new_password_confirmation},
    } = req;
    // const user = await User.findOne({id: loggedIn});
    const match = await bcrypt.compare(password, user.password);

    if (!match) {
        return res.status(400).json({message: "비밀번호가 틀립니다"});
    }

    if (new_password_confirmation !== new_password) {
        return res.status(400).json({message: "두 비밀번호가 틀립니다"});
    }

    await User.findByIdAndUpdate(
        {_id: user._id},
        {
            password: await bcrypt.hash(new_password, config.bcrypt.salt),
        }
    );

    return res.json({message: "비밀번호 변경 완료!"});
};

export const getFind = async (req, res, next) => {
    const {nick_name} = req.query;

    const user = await User.findOne({nick_name});

    if (!user) {
        console.log("asdad");
        return res.json({error: "User not found"});
    }
    return res.status(200).json({usename: user.name});
};

export const putEdit = async (req, res, next) => {
    const user = req.user;
    const newNickNmae = req.body.nick_name;

    const existNick = await User.exists({nick_name: newNickNmae});

    if (existNick) {
        return res.json({message: "중복됩니다."});
    }
    try {
        await User.findByIdAndUpdate(
            {_id: user._id},
            {
                nick_name: newNickNmae,
            }
        );
        return res.json(user.nick_name);
    } catch (error) {
        return res.json({messege: error});
    }
};

export const deleteUser = async (req, res, next) => {
    const {id} = req.params;

    const user = req.user;
    console.log(req.user);
    if (id !== user.id) {
        return res
            .status(401)
            .json({message: "계정을 삭제할 권리가 없습니다."});
    }

    await User.findByIdAndRemove(user._id);

    return res.status(200).json({message: "삭제되었습니다 "});
};

export const auth = async (req, res, next) => {
    const user = await User.findOne({id: req.user.id});
    console.log(req.user.id);
    if (!user) {
        return res.status(404).json({message: "User not found"});
    }

    return res.status(200).json({token: req.token, user: user});
};

const createJwt = (user) => {
    return jwt.sign({user}, config.jwt.secretKey, {
        expiresIn: config.jwt.expireInSec,
    });
};
