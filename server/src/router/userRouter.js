import express from "express";
import {getFind} from "../controller/userController";
import {isAuth} from "../middleware/auth";
// 라우터
const userRouter = express.Router();

userRouter.get("/find", isAuth, getFind);

export default userRouter;
