import express from "express";
import {
    changePassword,
    deleteUser,
    getFind,
    putEdit,
<<<<<<< HEAD
    getMyProfile,
    postMyProfile,
    getFriendsList,
    getLogout,
=======
    remove,
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87
} from "../controller/userController";
import {isAuth} from "../middleware/auth";
// 라우터
const userRouter = express.Router();

userRouter.get("/find", isAuth, getFind);
<<<<<<< HEAD
userRouter.put("/:id([0-9a-zA-Z]{4,12})/edit", isAuth, putEdit);
=======
userRouter.put("/:id([0-9a-zA-Z]{4,12})", isAuth, putEdit);
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87
userRouter.put(
    "/:id([0-9a-zA-Z]{4,12})/change-password",
    isAuth,
    changePassword
);

<<<<<<< HEAD
userRouter
    .route("/myprofile")
    .all(isAuth)
    .get(getMyProfile)
    .post(postMyProfile);

userRouter.get("/friends", isAuth, getFriendsList);
userRouter.get("/logout", isAuth, getLogout);
userRouter.delete("/:id([0-9a-zA-Z]{4,12})", isAuth, deleteUser);
=======
userRouter.delete("/:id", isAuth, deleteUser);
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87

export default userRouter;
