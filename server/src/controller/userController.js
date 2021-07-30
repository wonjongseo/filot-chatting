import User from "../models/User";
import bcrypt from "bcrypt";
import jwt from "express-jwt";
// 작업용 홈페이지에 모든 유저 출력
export const home = async (req, res, next) => {
    // db에서 모든 유저 가져옴
    const users = await User.find({});

    //json
    res.status(200).json(users);
};

// get 로그인
// export const getJoin = (req, res, next) => {
//     res.json(join);
// };

// post 로그인
export const postJoin = async (req, res, next) => {
    // body에서 읽어옴
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
        return res.status(201).json(user.nickName);
    } catch (error) {
        console.error(error);
        // db에러 잡음
        res.json(error);
    }
};

// 유저 닉네임으로 유저 찾기
export const getFind = async (req, res, next) => {
    const {nickName} = req.query;

    const user = await User.findOne({nickName});

    return res.status(200).json(user);
    // res.render("profile", {user});
};

// get 로그인
// export const getLogin = (req, res, next) => {
//     res.render("login");
// };

// post 로그인
export const postLogin = async (req, res, next) => {
    const {id, password} = req.body;
    // 입력한 id로 db안 id 찾기

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

    return res.json({message: "로그인 성공!", user});
};
