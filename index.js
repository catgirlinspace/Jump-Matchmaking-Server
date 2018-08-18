const fs = require('fs')
const Koa = require('koa')
const morgan = require('koa-morgan')

const accessLogStream = fs.createWriteStream(__dirname + '/access.log', { flags: 'a' })
const app = module.exports = new Koa();

app.use(morgan('combined', { stream: accessLogStream }))

app.use((ctx) => {
  ctx.body = 'Hello, world!'
})

app.listen(8888)