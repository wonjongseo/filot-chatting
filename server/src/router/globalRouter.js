import express from "express";
import {home, postJoin, postLogin, getFind} from "../controller/userController";
//라우터
const globalRouter = express.Router();

globalRouter.get("/", home);
globalRouter.post("/users/login", postLogin);
globalRouter.post("/users/join", postJoin);
globalRouter.get("/find", getFind);

export default globalRouter;