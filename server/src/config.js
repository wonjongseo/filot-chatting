import dotenv from "dotenv";
dotenv.config();

const setting = (key, defaultValue = undefined) => {
    const value = process.env[key] || defaultValue;

    if (value == null) {
        throw new Error(`Key ${key}가 없습니다`);
    }
    return value;
};

export const config = {
    jwt: {
        secretKey: setting("JWT_SECRET"),
        expireInSec: parseInt(setting("JWT_EXPIRES_SEC", 100000)),
    },
    bcrypt: {
        salt: parseInt(setting("BCRYPT_SALT_ROUNDS", 5)),
    },
    host: {
        port: parseInt(setting("HOST_PORT", 8080)),
    },
    database: {
        url: setting("DATABASE_URL"),
    },
};
