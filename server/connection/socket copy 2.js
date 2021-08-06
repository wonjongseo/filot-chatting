import {Server} from "socket.io";
import jwt from "jsonwebtoken";
import {config} from "../src/config";
import axios from "axios";
import Chat from "../src/models/Chat";

const initSockettt = (server) => {
    const io = new Server(server);

    io.sockets.on("connection", function (socket) {
        // receives message from DB
        Chat.find(function (err, result) {
            for (var i = 0; i < result.length; i++) {
                var dbData = {
                    name: result[i].username,
                    message: result[i].text,
                };
                io.emit("preload", dbData);
            }
        });

        // sends message to other users + stores data(username + message) into DB
        socket.on("message", function (data) {
            io.sockets.emit("message", data);
            // add chat into the model
            var chat = new Chat({username: data.name, text: data.message});

            chat.save(function (err, data) {
                if (err) {
                    // TODO handle the error
                    console.log("error");
                }
                console.log("message is inserted");
            });
        });
    });
};

export default initSockettt;
