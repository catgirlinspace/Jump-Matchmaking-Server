const app = require('./index');
const server = app.listen();
const request = require('supertest').agent(server);

describe('Matchmaking Server', function() {
  after(function() {
    server.close();
  });

  it('should say "Hello, world!" at /', function(done) {
    request
    .get('/')
    .expect(200)
    .expect('Hello, world!', done);
  });
});