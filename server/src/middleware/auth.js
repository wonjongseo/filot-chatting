import jwt from "jsonwebtoken";
import {config} from "../config";
import User from "../models/User";

const AUTH_ERROR = {message: "Authentication Error"};

export const isAuth = async (req, res, next) => {
    const token = req.get("token");
    if (!token) {
        return res.status(401).json(AUTH_ERROR);
    }
    jwt.verify(token, config.jwt.secretKey, async (error, decoded) => {
        if (error) {
            return res.status(401).json(AUTH_ERROR);
        }

        const user = await User.findOne({id: decoded.id});
        if (!user) {
            return res.status(401).json(AUTH_ERROR);
        }
        req.id = user.id;
        next();
    });
};
