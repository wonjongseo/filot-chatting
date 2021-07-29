import express from "express";
import {getFind} from "../controller/userController";

const userRouter = express.Router();

userRouter.get("/find", getFind);

export default userRouter;
