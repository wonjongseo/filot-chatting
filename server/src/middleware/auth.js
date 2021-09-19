import jwt from "jsonwebtoken";
import {config} from "../config";
import User from "../models/User";

const AUTH_ERROR = {message: "Authentication Error"};

export const isAuth = async (req, res, next) => {
<<<<<<< HEAD
    const token = req.get("token");
    if (!token) {
        return res.status(401).json(AUTH_ERROR);
    }
=======
    const authHeader = req.get("Authorization");

    if (!(authHeader && authHeader.startsWith("Bearer "))) {
        return res.status(401).json(AUTH_ERROR);
    }

    const token = authHeader.split(" ")[1];
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87
    jwt.verify(token, config.jwt.secretKey, async (error, decoded) => {
        if (error) {
            return res.status(401).json(AUTH_ERROR);
        }

        const user = await User.findOne({id: decoded.id});
<<<<<<< HEAD
        if (!user) {
            return res.status(401).json(AUTH_ERROR);
        }
        req.id = user.id;
=======

        if (!user) {
            return res.status(401).json(AUTH_ERROR);
        }
        req.userId = user.id; // req.customData
        req.token = token;
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87
        next();
    });
};
