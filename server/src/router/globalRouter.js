import express from "express";
import {home, postJoin, postLogin} from "../controller/userController";
import {validateCredential, validateSignup} from "../middleware/validator";
//라우터
const globalRouter = express.Router();

globalRouter.get("/", home);
globalRouter.post("/login", postLogin);
globalRouter.post("/join", validateCredential, postJoin);

export default globalRouter;
