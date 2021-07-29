import express from "express";
import {getFind} from "../controller/userController";

// 라우터
const userRouter = express.Router();

userRouter.get("/find", getFind);

export default userRouter;
