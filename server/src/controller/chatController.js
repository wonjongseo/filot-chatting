import Chat from "../models/Chat";

export const getChatByUser = (req, res, next) => {
    const chats = Chat.find({});

    return res.json(chats);
};

export const postChatByUser = async (req, res, next) => {
    const {text} = req.body;
    const user = req.user;
    if (!user) {
        return res.json({message: "로그인을 먼저 해주세요"});
    }
    const chat = await Chat.create({
        text,
        userId: user._id,
    });
    return res.json(chat);
};

export const findChatByUser = (req, res, next) => {
    const {user} = req.user;
};
// const socket = new Socket(server);
// const chat = io.of("/chat").on("connection", function (socket) {
//     socket.on("chat message", function (data) {
//         console.log("message from client ", data);

//         const name = (socket.name = data.name);
//         const room = (socket.room = data.room);

//         socket.join(room);

//         chat.to(room).emit("chat message", data.msg);
//     });
// });
export const createChatRoom = (req, res, next) => {
    res.sendFile(__dirname + "/kokoatalk.html");
};
