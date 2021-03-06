import User from "../models/User";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import {config} from "../config";
<<<<<<< HEAD

export const home = async (req, res) => {
    const users = await User.find({});
    res.status(200).json(users);
};

export const postJoin = async (req, res) => {
    const {username, password, confirmpassword, name, phone_number} = req.body;

    if (password != confirmpassword) {
        return res.status(409).json({message: "비밀번호가 틀립니다"});
    }
    const existingUser = await User.exists({id: username});

    if (existingUser) {
=======
import {validateCredential} from "../middleware/validator";

export const home = async (req, res, next) => {
    // db에서 모든 유저 가져옴
    const users = await User.find({});

    res.status(200).json(users);
};

export const postJoin = async (req, res, next) => {
    const {id, password, password2, name, nick_name, phone_number} = req.body;

    // 입력한 두 비밀번호가 다르면 사용자 에러
    if (password != password2) {
        return res.status(409).json({message: "비밀번호가 틀립니다."});
    }
    const existUser = await User.exists({$or: [{id}, {nick_name}]});
    // 이미 존재하는 id라면 사용자 에러
    if (existUser) {
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87
        return res
            .status(409)
            .json({message: "아이디 혹은 닉넴이이 이미 사용중입니다."});
    }
<<<<<<< HEAD
    const newPassword = await bcrypt.hash(password, config.bcrypt.salt);
    try {
        const user = await User.create({
            id: username,
            password: newPassword,
            name,
=======
    try {
        // db안에 유저 생성
        const user = await User.create({
            id,
            password,
            password2,
            name,
            nick_name,
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87
            phone_number,
        });

        const token = createJwt(user.id);

<<<<<<< HEAD
        return res.status(200).json(token);
    } catch (error) {
        console.error(error);
        res.json({message: error});
=======
        return res.status(201).json({token, nick_name});
    } catch (error) {
        console.error(error);
        // db에러 잡음
        res.json(error);
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87
    }
};

export const postLogin = async (req, res, next) => {
<<<<<<< HEAD
    const {username, password} = req.body;
    const user = await User.findOne({id: username});
    // 없으면 사용자 에러
    if (!user) {
        return res.status(401).json({message: "없는 아이디입니다."});
    }
    // 비밀번호 확인
    const match = await bcrypt.compare(password, user.password);

    if (!match) {
        return res.status(401).json({message: "비밀번호가 틀려요."});
    }
    const token = createJwt(user.id);
    req.headers.token = token;
    return res.json({token: token});
};

export const changePassword = async (req, res, next) => {
    const {
        id,
        body: {password, new_password, new_password_confirmation},
    } = req;

    const user = await User.findById({id});
    // const user = await User.findOne({id: loggedIn});
    const match = await bcrypt.compare(password, user.password);
    if (!match) {
        return res.status(400).json({message: "비밀번호가 틀립니다"});
    }
    if (new_password_confirmation !== new_password) {
        return res.status(400).json({message: "두 비밀번호가 틀립니다"});
    }
=======
    const {id, password} = req.body;
    const user = await User.findOne({id});
    // 없으면 사용자 에러
    if (!user) {
        return res.status(401).json({errorMessage: "없는 아이디입니다."});
    }
    // 비밀번호 확인
    const match = await bcrypt.compare(password, user.password);
    console.log(match);
    if (!match) {
        return res.status(401).json({errorMessage: "비밀번호가 틀려요."});
    }
    const token = createJwt(user.id);
    return res.json({message: "로그인 성공!", user, token});
};

export const changePassword = async (req, res, next) => {
    const {id} = req.params; // 없어도 될듯
    const loggedIn = req.userId;
    const user = await User.findOne({id: loggedIn});
    console.log(user);

    const {password, new_password} = req.body;
    const match = await bcrypt.compare(password, user.password);
    if (!match) {
        return res.json({message: "비밀번호가 틀립니다"});
    }

    console.log(`old password : ${user.password}`);

>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87
    await User.findByIdAndUpdate(
        {_id: user._id},
        {
            password: await bcrypt.hash(new_password, config.bcrypt.salt),
        }
    );
<<<<<<< HEAD
=======
    console.log(`new password : ${user.password}`);
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87
    return res.json({message: "비밀번호 변경 완료!"});
};

export const getFind = async (req, res, next) => {
<<<<<<< HEAD
    const {name} = req.query;
    const user = await User.findOne({name}).select(
        "name, role,github,email, phone_number "
    );
    if (!user) {
        return res.json({error: "User not found"});
    }
    console.log(user);
    return res.status(200).json({user});
};

export const putEdit = async (req, res, next) => {
    const user = req.user;
    const newNickNmae = req.body.name;
    const existNick = await User.exists({name: newNickNmae});

=======
    const {nick_name} = req.query;

    const user = await User.findOne({nick_name});

    return res.status(200).json(user);
};

export const putEdit = async (req, res, next) => {
    const loggedIn = req.userId;
    const newNickNmae = req.body.nick_name;

    const user = await User.findOne({id: loggedIn});

    if (!user) {
        return res.status(401).json({message: "없는 아이디 입니다."});
    }
    const existNick = await User.exists({nick_name: newNickNmae});
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87
    if (existNick) {
        return res.json({message: "중복됩니다."});
    }
    try {
        await User.findByIdAndUpdate(
            {_id: user._id},
            {
<<<<<<< HEAD
                name: newNickNmae,
            }
        );
        return res.json(user.name);
=======
                nick_name: newNickNmae,
            }
        );
        return res.json(user.nick_name);
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87
    } catch (error) {
        return res.json({messege: error});
    }
};

<<<<<<< HEAD
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
    const user = await User.findOne({id: req.id});
    if (!user) {
        return res.status(404).json({message: "User not found"});
    }
    return res.status(200).json({token: req.token, user: user});
};

export const getMyProfile = async (req, res, next) => {
    // 미들웨어에서 토큰 처리
    const {id} = req;
    var user = await User.findOne({id});
    user = {
        state: user.state,
        name: user.name,
        phone_number: user.phone_number,
        role: user.role,
        github: user.github,
        email: user.email,
    };

    console.log(typeof user);
    return res.status(200).json(user);
};

export const postMyProfile = async (req, res, next) => {
    const {state, role, github, email, phone_number} = req.body;
    const {id} = req;

    const user = await User.findOneAndUpdate(
        {id},
        {
            state,
            role,
            github,
            email,
            phone_number,
        }
    );
    console.log(user);
    return res.status(201).json(user);
};

export const getFriendsList = async (req, res, next) => {
    const {id} = req;

    const users = await User.find({
        id: {
            $ne: id,
            // 본인 제외
        },
    }).select("-password -_id -rooms -id");
    console.log(users);
    return res.status(200).json(users);
};

//OK
=======
export const deleteUser = (req, res, next) => {};

export const auth = async (req, res, next) => {
    const user = await User.findOne({id: req.userId});

    if (!user) {
        return res.status(404).json({message: "User not found"});
    }

    return res.status(200).json({token: req.token, username: user.nick_name});
};

>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87
const createJwt = (id) => {
    return jwt.sign({id}, config.jwt.secretKey, {
        expiresIn: config.jwt.expireInSec,
    });
};
<<<<<<< HEAD

export const getLogout = (req, res, next) => {
    return jwt.sign({id}, config.jwt.secretKey, {
        expiresIn: 100,
    });
};
=======
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87
