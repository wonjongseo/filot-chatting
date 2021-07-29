import express from "express";
import {
    getJoin,
    getLogin,
    home,
    postJoin,
    postLogin,
} from "../controller/userController";

const globalRouter = express.Router();

globalRouter.get("/", home);
globalRouter.route("/login").get(getLogin).post(postLogin);
globalRouter.route("/join").get(getJoin).post(postJoin);

export default globalRouter;
