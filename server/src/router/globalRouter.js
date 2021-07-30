import express from "express";
import {home, postJoin, postLogin} from "../controller/userController";
import {validateCredential} from "../middleware/validator";
//라우터
const globalRouter = express.Router();

globalRouter.get("/", home);
globalRouter.post("/login", validateCredential, postLogin);
globalRouter.post("/join", validateSignup, postJoin);

export default globalRouter;
