import User from "../models/User";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import {config} from "../config";

export const home = async (req, res, next) => {
    // db에서 모든 유저 가져옴
    const users = await User.find({});

    res.status(200).json(users);
};

export const postJoin = async (req, res, next) => {
    const {id, password, confirmPassword, nickName, introduction} = req.body;
    // 입력한 두 비밀번호가 다르면 사용자 에러
    if (password != confirmPassword) {
        return res.status(409).json({message: "비밀번호가 틀립니다."});
    }
    const existUser = await User.exists({$or: [{id}, {nickName}]});
    // 이미 존재하는 id라면 사용자 에러
    if (existUser) {
        return res
            .status(409)
            .json({message: "아이디 혹은 닉넴이이 이미 사용중입니다."});
    }
    try {
        // db안에 유저 생성
        const user = await User.create({
            id,
            nickName,
            password,
            introduction,
        });

        const token = createJwt(user.id);

        return res.status(201).json({token, nickName});
    } catch (error) {
        console.error(error);
        // db에러 잡음
        res.json(error);
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
    const comfirmed = await bcrypt.compare(password, user.password);
    if (!comfirmed) {
        return res.status(401).josn({errorMessage: "비밀번호가 틀려요."});
    }
    const token = createJwt(user.id);
    return res.json({message: "로그인 성공!", user, token});
};

export const getFind = async (req, res, next) => {
    const {nickName} = req.query;

    const user = await User.findOne({nickName});

    return res.status(200).json(user);
};

export const auth = async (req, res, next) => {
    const user = await User.findOne({id: req.userId});
    console.log("req.userId : ", req.userId);
    if (!user) {
        return res.status(404).json({message: "User not found"});
    }
    // console.log(req.token);
    return res.status(200).json({token: req.token, username: user.id});
};

const createJwt = (id) => {
    return jwt.sign({id}, config.jwt.secretKey, {
        expiresIn: config.jwt.expireInSec,
    });
};