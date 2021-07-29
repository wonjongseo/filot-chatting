import express from "express";
import {getJoin, home, postJoin} from "../controller/userController";

const globalRouter = express.Router();

globalRouter.get("/", home);
globalRouter.route("/join").get(getJoin).post(postJoin);
globalRouter.route("/login");

export default globalRouter;
