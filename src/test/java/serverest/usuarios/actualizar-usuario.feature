Feature: PUT /usuarios/{_id} - Actualizar usuario

  Background:
    * url baseUrl
    * def nuevo = call read('classpath:serverest/common/helpers/crear-usuario.feature')
    * def usuario = nuevo.usuario

  Scenario: Actualizar los datos de un usuario existente
    * set usuario.nome = 'Nombre Actualizado'
    * set usuario.administrador = 'false'

    Given path 'usuarios', nuevo.id
    And request usuario
    When method put
    Then status 200
    And match response.message == 'Registro alterado com sucesso'

    Given path 'usuarios', nuevo.id
    When method get
    Then status 200
    And match response.nome == 'Nombre Actualizado'
    And match response.administrador == 'false'

    * call read('classpath:serverest/common/helpers/eliminar-usuario.feature') { id: '#(nuevo.id)' }

  Scenario: No se puede actualizar un usuario con el email de otro usuario
    * def otro = call read('classpath:serverest/common/helpers/crear-usuario.feature')
    * set usuario.email = otro.usuario.email

    Given path 'usuarios', nuevo.id
    And request usuario
    When method put
    Then status 400
    And match response.message == 'Este email já está sendo usado'

    * call read('classpath:serverest/common/helpers/eliminar-usuario.feature') { id: '#(nuevo.id)' }
    * call read('classpath:serverest/common/helpers/eliminar-usuario.feature') { id: '#(otro.id)' }

  Scenario: No se puede actualizar un usuario sin nome
    * remove usuario.nome

    Given path 'usuarios', nuevo.id
    And request usuario
    When method put
    Then status 400
    And match response.nome == 'nome é obrigatório'

    * call read('classpath:serverest/common/helpers/eliminar-usuario.feature') { id: '#(nuevo.id)' }

  Scenario: Actualizar un ID que no existe crea un usuario nuevo
    # ServeRest crea el usuario si el ID no existe
    * def otroUsuario = call read('classpath:serverest/common/utils/data-generator.js')

    Given path 'usuarios', 'idNoExiste123456'
    And request otroUsuario
    When method put
    Then status 201
    And match response == { message: 'Cadastro realizado com sucesso', _id: '#string' }

    * call read('classpath:serverest/common/helpers/eliminar-usuario.feature') { id: '#(response._id)' }
    * call read('classpath:serverest/common/helpers/eliminar-usuario.feature') { id: '#(nuevo.id)' }
