import express from "express";
import {
    changePassword,
    deleteUser,
    getFind,
    putEdit,
    remove,
} from "../controller/userController";
import {isAuth} from "../middleware/auth";
// 라우터
const userRouter = express.Router();

userRouter.get("/find", isAuth, getFind);
userRouter.put("/:id([0-9a-zA-Z]{4,12})", isAuth, putEdit);
userRouter.put(
    "/:id([0-9a-zA-Z]{4,12})/change-password",
    isAuth,
    changePassword
);

userRouter.delete("/:id", isAuth, deleteUser);

export default userRouter;
