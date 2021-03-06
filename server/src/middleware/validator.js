import {validationResult, body} from "express-validator";

const validator = (req, res, next) => {
    const error = validationResult(req);

    if (error.isEmpty()) {
        return next();
    }
    return res.status(400).json({message: error.array()[0].msg});
};

export const validateCredential = [
    body("id")
        .trim()
        .notEmpty()
        .isLength({min: 5})
        .withMessage("5글자 이상 입력해주세요"),
    body("password")
        .trim()
        .isLength({min: 5})
        .withMessage("5글자 이상 입력해주세요"),
    validator,
];

export const validateSignup = [
    ...validateCredential,
<<<<<<< HEAD
=======
    body("nick_name").trim().notEmpty().withMessage("닉네임을 적어주세요"),
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87
    // body("phoneNumber")
    //     .trim()
    //     .isMobilePhone()
    //     .withMessage("전화번호를 입력해주세요"),
    validator,
];
