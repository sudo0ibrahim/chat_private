import express, { response } from "express";
import * as fs from 'fs';
import morgan from "morgan";
import { v4 as uuidv4 } from 'uuid';


const app = express()

const PORT = 3000;

app.use(express.json())
app.use(morgan('combined'))



function isAuth(request, response, next) {

    const data = fs.readFileSync('password.json','utf-8');
    const mydata = JSON.parse(data)

    const auth = request.headers.authorization;
    if (auth === mydata["password"]) {
        next();
    } else {
        response.status(401);
        response.send('Access forbidden');
    }
}

let chat = []
let id_ = []

app.get('/',isAuth, (request, response) => {
    response.send("hello")

})

app.get('/message', isAuth, (request, response) => {
    response.json(chat)
})

app.get('/message/id', isAuth, (request, response) => {
    response.json(id_)
})

app.get('/message/:id', isAuth, (request, response) => {
    const id = request.params.id
    const message = chat.find((message) => message.id === id)
    if(message){
        response.json([message])
    }
    else{
        response.sendStatus(404)
    }

})

app.post('/message',isAuth, (request, response) => {
    const id = uuidv4()
    const username = request.body.username
    const message = request.body.message
    
    const person = {
        username:username,
        message:message
    }

    if (!username && !message) {
        return response.sendStatus(400);
    }

    id_.push({id})
    chat.push({id,username,message})

    response.status(201).json({
        username: username,
        message: message
    });


})

app.listen(PORT, () => {
    console.log(`The server run in port tor ${PORT}`)
})
