function fn() {
  var numero = new Date().getTime() + '' + Math.floor(Math.random() * 1000);

  return {
    nome: 'Usuario QA ' + numero,
    email: 'qa' + numero + '@test.com',
    password: 'teste123',
    administrador: 'true'
  };
}
