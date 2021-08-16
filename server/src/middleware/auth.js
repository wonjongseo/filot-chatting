import jwt from "jsonwebtoken";
import {config} from "../config";
import User from "../models/User";

const AUTH_ERROR = {message: "Authentication Error"};

export const isAuth = async (req, res, next) => {
    // console.log(req.headers);
    // const authHeader = req.get("Authorization");

    // if (!(authHeader && authHeader.startsWith("Bearer "))) {
    //     return res.status(401).json(AUTH_ERROR);
    // }

    // const token = authHeader.split(" ")[1];
    const token = req.get("token");
    jwt.verify(token, config.jwt.secretKey, async (error, decoded) => {
        if (error) {
            return res.status(401).json(AUTH_ERROR);
        }

        const user = await User.findOne({id: decoded.id});
        if (!user) {
            return res.status(401).json(AUTH_ERROR);
        }
        req.token = token;
        req.id = user.id;
        req.headers.token = token;
        console.log(`req.headers : ${req.headers}`);
        next();
    });
};
