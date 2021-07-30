import express from "express";
import {
    getJoin,
    getLogin,
    home,
    postJoin,
    postLogin,
} from "../controller/userController";

//라우터
const globalRouter = express.Router();

globalRouter.get("/", home);
globalRouter.route("/login").get(getLogin).post(postLogin);
globalRouter.route("/join").get(getJoin).post(postJoin);
// globalRouter.post("/join", postJoin);

export default globalRouter;
