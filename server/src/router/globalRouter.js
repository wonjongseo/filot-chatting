import express from "express";
<<<<<<< HEAD
import {home, postJoin, postLogin, getFind} from "../controller/userController";
=======
import {home, postJoin, postLogin} from "../controller/userController";
import {validateCredential, validateSignup} from "../middleware/validator";
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87
//라우터
const globalRouter = express.Router();

globalRouter.get("/", home);
<<<<<<< HEAD
globalRouter.post("/users/login", postLogin);
globalRouter.post("/users/join", postJoin);
globalRouter.get("/find", getFind);
=======
globalRouter.post("/login", postLogin);
globalRouter.post("/join", validateCredential, postJoin);
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87

export default globalRouter;
